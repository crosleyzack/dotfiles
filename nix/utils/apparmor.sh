#!/bin/bash

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
