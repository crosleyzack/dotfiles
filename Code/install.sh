#!/bin/bash

echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections

sudo apt-get install wget gpg &&
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg &&
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg &&
rm -f microsoft.gpg

# rm /etc/apt/sources.list.d/vscode.sources
# echo "Types: deb
# URIs: https://packages.microsoft.com/repos/code
# Suites: stable
# Components: main
# Architectures: amd64,arm64,armhf
# Signed-By: /usr/share/keyrings/microsoft.gpg" > /etc/apt/sources.list.d/vscode.sources

sudo apt install apt-transport-https &&
sudo apt update &&
sudo apt install code
