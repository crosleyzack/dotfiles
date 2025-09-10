#!/bin/bash

# NOTE: this can also be run to update nix version. Simply change `23.11` below to the appropriate value
VERSION="23.11"

# Install nix package manager
NIX_PATH=$(which nix)
if [[ -z "$NIX_PATH" ]]; then
    echo "NIX not installed, installing"
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
fi
# Add nixpkgs stable and unstable
sudo -i nix-channel --remove nixpkgs
sudo -i nix-channel --add "https://channels.nixos.org/nixos-$VERSION" nixpkgs
sudo -i nix-channel --remove unstable
sudo -i nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
# Install home manager
sudo -i nix-channel --remove home-manager
sudo -i nix-channel --add "https://github.com/nix-community/home-manager/archive/release-$VERSION.tar.gz" home-manager
sudo -i nix-channel --update
# setup home manager
echo "Home manager installed, the command to setup may not work until after a restart"
nix-shell '<home-manager>' -A install
