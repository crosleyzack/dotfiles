#!/bin/bash

################################################################################
# AppArmor Configuration for Nix-Installed VSCode
#
# Purpose:
#   Creates an AppArmor profile to allow Nix-installed VSCode to run its
#   Chromium sandbox properly, which is typically blocked by default AppArmor
#   policies.
#
# Problem:
#   VSCode installed via Nix uses a chrome-sandbox binary that requires special
#   permissions. AppArmor's default security policies block user namespace
#   creation for binaries in /nix/store, causing VSCode to fail on startup with
#   a SUID sandbox configuration error.
#
# Behavior:
#   1. Verifies apparmor-utils is installed
#   2. Removes any existing nix.store.vscode profile and disable symlinks
#   3. Creates a new AppArmor profile at /etc/apparmor.d/nix.store.vscode
#   4. The profile allows user namespace (userns) creation for:
#      - /nix/store/**/bin/code
#      - /nix/store/**/lib/vscode/code
#      - /nix/store/**/lib/vscode/chrome-sandbox
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

# AppArmor will initially block running vscode installed from nix due to the permissions on the sandbox binary:
# [66700:0209/101041.044195:FATAL:sandbox/linux/suid/client/setuid_sandbox_host.cc:169] The SUID sandbox helper binary was found, but is not configured correctly. Rather than run without sandboxing I'm aborting now. You need to make sure that /nix/store/g9vfy3ab76xqnry71jdc5jgw4h3is85g-vscode-1.106.2/lib/vscode/chrome-sandbox is owned by root and has mode 4755.
# This sets up a rule allowing user namespace to run nix installed vscode

DEST=/etc/apparmor.d/nix.store.vscode

if [ ! -f "$(command -v aa-enforce)" ]; then
    echo "apparmor-utils must be installed. You probably want 'sudo apt-get install apparmor-utils'"
    exit 1
fi

if [ -f $DEST ]; then
    # profile already exists, remove it
    sudo rm -rf $DEST
    # Remove the disable symlink if it exists
    sudo rm -f /etc/apparmor.d/disable/nix.store.vscode
fi

FILE=$(cat <<EOF
# allow nix installed sandbox
abi <abi/4.0>,
include <tunables/global>

# Profile for Nix-installed VSCode
# For file paths matching '/nix/store/**/...', allow requests from user namespace (userns)
# This allows the SUID chrome sandbox to run
profile nix_vscode /nix/store/**{/bin/code,/lib/vscode/code,/lib/vscode/chrome-sandbox} flags=(unconfined) {
  userns,
}
EOF
)
echo "$FILE" | sudo tee $DEST

# enable profile
sudo apparmor_parser -r $DEST
sudo systemctl restart apparmor
