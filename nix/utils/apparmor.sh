#!/bin/bash

# Fix vscode error:
# [66700:0209/101041.044195:FATAL:sandbox/linux/suid/client/setuid_sandbox_host.cc:169] The SUID sandbox helper binary was found, but is not configured correctly. Rather than run without sandboxing I'm aborting now. You need to make sure that /nix/store/g9vfy3ab76xqnry71jdc5jgw4h3is85g-vscode-1.106.2/lib/vscode/chrome-sandbox is owned by root and has mode 4755.
# still blocked by apparmor_restrict_unprivileged_userns

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


# create profile
FILE=$(cat <<EOF
# allow nix installed sandbox
abi <abi/4.0>,
include <tunables/global>

# Profile for Nix-installed VSCode
# The 'flags=(unconfined)' effectively makes this profile a named placeholder
# that allows everything, but importantly enables user namespaces.
profile nix_vscode /nix/store/**{/bin/code,/lib/vscode/code,/lib/vscode/chrome-sandbox} flags=(unconfined) {
  userns,
}
EOF
)
echo "$FILE" | sudo tee $DEST

# enable profile
sudo apparmor_parser -r $DEST
sudo systemctl restart apparmor
