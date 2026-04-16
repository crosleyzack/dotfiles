#!/bin/bash

################################################################################
# AppArmor Configuration for Nix-Installed Chromium (used by VHS)
#
# Purpose:
#   Creates an AppArmor profile to allow Nix-installed Chromium to run its
#   SUID sandbox properly when invoked by VHS (terminal recorder).
#
# Problem:
#   VHS uses a headless Chromium browser to render terminal recordings.
#   Chromium installed via Nix uses a SUID sandbox binary that requires special
#   permissions. AppArmor's default security policies block user namespace
#   creation for binaries in /nix/store, causing VHS to fail with:
#   "The SUID sandbox helper binary was found, but is not configured correctly.
#    Rather than run without sandboxing I'm aborting now. You need to make sure
#    that /nix/store/...chromium...-sandbox/bin/__chromium-suid-sandbox is
#    owned by root and has mode 4755."
#
# Behavior:
#   1. Verifies apparmor-utils is installed
#   2. Removes any existing nix.store.chromium profile and disable symlinks
#   3. Creates a new AppArmor profile at /etc/apparmor.d/nix.store.chromium
#   4. The profile allows user namespace (userns) creation for:
#      - /nix/store/**/bin/chromium
#      - /nix/store/**/bin/chromium-browser
#      - /nix/store/**/bin/__chromium-suid-sandbox
#   5. Loads the profile into AppArmor
#   6. Restarts the AppArmor service to apply changes
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - apparmor-utils installed (sudo apt-get install apparmor-utils)
#   - Sudo privileges
#   - AppArmor-enabled system
#
# Note:
#   This profile uses the 'unconfined' flag, which allows the matched binaries
#   to run with minimal restrictions while still enforcing the userns permission.
################################################################################

DEST=/etc/apparmor.d/nix.store.chromium

if [ ! -f "$(command -v aa-enforce)" ]; then
    echo "apparmor-utils must be installed. You probably want 'sudo apt-get install apparmor-utils'"
    exit 1
fi

if [ -f $DEST ]; then
    # profile already exists, remove it
    sudo rm -rf $DEST
    # Remove the disable symlink if it exists
    sudo rm -f /etc/apparmor.d/disable/nix.store.chromium
fi

FILE=$(cat <<EOF
# allow nix installed chromium sandbox (used by VHS)
 abi <abi/4.0>,
include <tunables/global>

# Profile for Nix-installed Chromium
# For file paths matching '/nix/store/**/...', allow requests from user namespace (userns)
# This allows the SUID chromium sandbox to run (required by VHS terminal recorder)
profile nix_chromium /nix/store/**{/bin/chromium,/bin/chromium-browser,/bin/__chromium-suid-sandbox} flags=(unconfined) {
  userns,
}
EOF
)
echo "$FILE" | sudo tee $DEST

# enable profile
sudo apparmor_parser -r $DEST
sudo systemctl restart apparmor
