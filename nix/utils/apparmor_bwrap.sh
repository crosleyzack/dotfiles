#!/bin/bash

################################################################################
# AppArmor Configuration for Bubblewrap (bwrap)
#
# Purpose:
#   Installs an AppArmor profile that lets /usr/bin/bwrap create unprivileged
#   user namespaces. This unblocks tools that rely on bubblewrap as their
#   container runner (notably melange) on Ubuntu 24.04 and other distros that
#   ship the restricted-userns AppArmor policy.
#
# Problem:
#   Starting with Ubuntu 23.10 (and enforced in 24.04), the kernel restricts
#   unprivileged user namespace creation behind AppArmor. Binaries without an
#   explicit profile granting `userns` fail with:
#       bwrap: setting up uid map: Permission denied
#   This breaks melange builds, which shell out to bwrap for sandboxing. See:
#       https://github.com/chainguard-dev/melange/issues/1508
#
# Behavior:
#   1. Verifies apparmor-utils is installed
#   2. Removes any existing /etc/apparmor.d/nix.store.bwrap profile and its
#      disable symlink, so this script is safely re-runnable
#   3. Writes a new profile named `local-bwrap` for /usr/bin/bwrap that:
#        - runs with flags=(unconfined) so bwrap can do its own sandboxing
#        - grants the `userns` permission required to map uids/gids
#        - includes <local/bwrap> for site-specific overrides
#   4. Reloads the profile with apparmor_parser -r
#   5. Restarts the apparmor service to apply changes
#
# Prerequisites:
#   - apparmor-utils installed (sudo apt-get install apparmor-utils)
#   - Sudo privileges
#   - AppArmor-enabled system (Ubuntu 23.10+ is the common case)
#
# Alternatives (not used here):
#   - Disabling the restriction system-wide via
#       kernel.apparmor_restrict_unprivileged_userns = 0
#     in /etc/sysctl.d/. That is broader than necessary; this script narrows
#     the exception to bwrap only.
################################################################################

DEST=/etc/apparmor.d/nix.store.bwrap

if [ ! -f "$(command -v aa-enforce)" ]; then
    echo "apparmor-utils must be installed. You probably want 'sudo apt-get install apparmor-utils'"
    exit 1
fi

if [ -f $DEST ]; then
    # profile already exists, remove it
    sudo rm -rf $DEST
    # Remove the disable symlink if it exists
    sudo rm -f /etc/apparmor.d/disable/nix.store.bwrap
fi

FILE=$(cat <<EOF
# allow bubble wrap to run with user namespaces, which is required for the sandbox to work
abi <abi/4.0>,
include <tunables/global>

profile local-bwrap /usr/bin/bwrap flags=(unconfined) {
  userns,

  # Site-specific additions and overrides. See local/README for details.
  include if exists <local/bwrap>
}
EOF
)
echo "$FILE" | sudo tee $DEST

# enable profile
sudo apparmor_parser -r $DEST
sudo systemctl restart apparmor
