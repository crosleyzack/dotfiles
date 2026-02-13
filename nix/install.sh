#!/bin/bash

# NOTE: this can also be run to update nix version. Simply change `VERSION` below to the appropriate value. See https://nixos.wiki/wiki/Nix_channels
VERSION="${NIX_VERSION:-25.11}"
SETUP_CHANNEL="${SETUP_NIX_CHANNEL:-true}"
INSTALL_HOME_MANAGER="${SETUP_HOME_MANAGER:-true}"

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
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update

    # install home manager
    nix-shell '<home-manager>' -A install

    # setup system link, depending on system name
    SYSNAME="$(sudo dmidecode -s system-manufacturer| awk '{print tolower($0)}')"
    [ "$SYSNAME" == "framework" ] && ln -s $DIR_PATH/framework $DIR_PATH/system
    [ "$SYSNAME" == "lenovo" ] && ln -s $DIR_PATH/lenovo $DIR_PATH/system
    [ "$SYSNAME" == "google" ] && ln -s $DIR_PATH/google $DIR_PATH/system

    echo "INFO: installing packages for $SYSNAME"
    cd system && home-manager switch -b backup --flake .
fi

echo "\nInstall completed. Relaunch shell to use nix\n"
