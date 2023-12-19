#!/bin/bash

# NOTE: this can also be run to update nix version. Simply change `23.11` below to the appropriate value

# Install nix package manager
NIX_PATH=$(which nix)
if [[ -z "$NIX_PATH" ]]; then
    echo "NIX not installed, installing"
    sh <(curl -L https://nixos.org/nix/install) --daemon
fi
# Add nixpkgs stable and unstable
sudo -i nix-channel --remove nixpkgs
sudo -i nix-channel --add https://channels.nixos.org/nixos-23.11 nixpkgs
sudo -i nix-channel --remove unstable
sudo -i nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
# Install home manager
sudo -i nix-channel --remove home-manager
sudo -i nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
sudo -i nix-channel --update
nix-shell '<home-manager>' -A install
