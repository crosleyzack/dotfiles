#!/bin/sh

echo "WARN this lacks the ability to update because debian"

# Remove old
sudo apt-add-repository --remove ppa:yubico/stable
sudo apt remove yubikey-manager
# install new
sudo apt install python3-launchpadlib
sudo apt-add-repository ppa:yubico/stable
sudo apt update
sudo apt install yubikey-manager
