#!/bin/bash

# NOTE: this can also be run to update nix version. Simply change `VERSION` below to the appropriate value. See https://nixos.wiki/wiki/Nix_channels
VERSION="${NIX_VERSION:-25.11}"
SETUP_CHANNEL="${SETUP_NIX_CHANNEL:-true}"
INSTALL_HOME_MANAGER="${SETUP_HOME_MANAGER:-true}"
INSTALL_NIX_PKGS="${SETUP_NIX_PKGS:-false}"

# get dir containing this file
FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

# Install nix package manager
if [[ -z "$(which nix-env)" ]]; then
    echo "\nnix not installed, installing"

    # sym links nix config
    mkdir -p $HOME/.config/nix
    rm -f $HOME/.config/nix/nix.conf
    ln -s $DIR_PATH/nix.conf $HOME/.config/nix/nix.conf

    # install
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon --yes

    # source after install
    source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

# Add nixpkgs stable and unstable
if $SETUP_CHANNEL; then
    # remove the default channels
    nix-channel --remove unstable
    nix-channel --remove nixpkgs

    # add specified version
    nix-channel --add "https://channels.nixos.org/nixos-$VERSION" nixpkgs
    nix-channel --update
fi

# Install home manager
if $INSTALL_HOME_MANAGER; then
    echo "\ninstalling home manager"

    # add and sync channel
    nix-channel --remove home-manager
    nix-channel --add "https://github.com/nix-community/home-manager/archive/release-$VERSION.tar.gz" home-manager
    nix-channel --update

    # sym link 
    # mkdir -p $HOME/.config/home-manager
    # rm -f $HOME/.config/home-manager/home.nix
    # rm -rf $HOME/.config/home-manager/home
    # cp $DIR_PATH/home.nix $HOME/.config/home-manager/home.nix
    # cp -r $DIR_PATH/home $HOME/.config/home-manager/home

    # install home manager
    nix-shell '<home-manager>' -A install

    # setup system link, depending on system name
    SYSNAME="$(sudo dmidecode -s system-manufacturer)"
    [ "$SYSNAME" == "Framework" ] && ln -s $DIR_PATH/framework $DIR_PATH/system
    [ "$SYSNAME" == "Lenovo" ] && ln -s $DIR_PATH/lenovo $DIR_PATH/system

    cd system && home-manager switch --flake .
    # nix run home-manager/release-25.11 -- init --switch -b backup
fi

# Install packages without home manager
if $INSTALL_NIX_PKGS; then
    mkdir -p $HOME/.config/nixpkgs
    rm -f $HOME/.config/nixpkgs/config.nix
    ln -s $DIR_PATH/config.nix $HOME/.config/nixpkgs/config.nix
    nix-env -iA nixpkgs.myPackages
fi

echo "\nInstall completed. Relaunch shell to use nix\n"
