#!/bin/bash

# NOTE: this can also be run to update nix version. Simply change `VERSION` below to the appropriate value. See https://nixos.wiki/wiki/Nix_channels
VERSION="25.05"
SETUP_CHANNEL=true
INSTALL_HOME_MANAGER=false

# Install nix package manager
NIX_PATH=$(which nix)
if [[ -z "$NIX_PATH" ]]; then
    echo "NIX not installed, installing"
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
    # source after install
    source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

# Add nixpkgs stable and unstable
if $SETUP_CHANNEL; then
	nix-channel --remove nixpkgs
	nix-channel --add "https://channels.nixos.org/nixos-$VERSION" nixpkgs
fi

# Install home manager
if $INSTALL_HOME_MANAGER; then
	sudo -i nix-channel --remove home-manager
	sudo -i nix-channel --add "https://github.com/nix-community/home-manager/archive/release-$VERSION.tar.gz" home-manager
	sudo -i nix-channel --update
	# setup home manager
	echo "Home manager installed, the command to setup may not work until after a restart"
	nix-shell '<home-manager>' -A install
fi
