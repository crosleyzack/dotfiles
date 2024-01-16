#!/bin/sh

sudo apt install python3-launchpadlib
sudo apt-add-repository ppa:yubico/stable
sudo apt update
sudo apt install yubikey-manager
