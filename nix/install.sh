#!/bin/bash

################################################################################
# Nix Package Manager Installation and Configuration Script
#
# Purpose:
#   Installs and configures Nix package manager and home-manager.
#   This script performs a single-user installation (--no-daemon) and
#   sets up system-specific configurations.
#
# Behavior:
#   1. Installs Nix package manager if not already present
#   2. Symlinks Nix configuration file (nix.conf) to ~/.config/nix/
#   3. Configures Nix channels (nixpkgs stable)
#   4. Installs home-manager and sets up the appropriate channel
#   5. Auto-detects or uses provided system ID to apply machine-specific configs
#   6. Applies home-manager flake configuration from the system-specific directory
#
# Environment Variables:
#   NIX_VERSION          - Nix channel version to install (default: 25.11)
#                          See: https://nixos.wiki/wiki/Nix_channels
#   SETUP_NIX_CHANNEL    - Whether to setup Nix channels (default: true)
#   SETUP_HOME_MANAGER   - Whether to install home-manager (default: true)
#   NIX_SYSTEM_ID        - System identifier: 'framework', 'lenovo', or 'google'
#                          Auto-detected via dmidecode if not set
#
# Note:
#   This script can also be run to update the Nix version by changing the
#   NIX_VERSION environment variable to the desired version.
################################################################################

# NOTE: this can also be run to update nix version. Simply change `VERSION` below to the appropriate value. See https://nixos.wiki/wiki/Nix_channels
VERSION="${NIX_VERSION:-25.11}"
SETUP_CHANNEL="${SETUP_NIX_CHANNEL:-true}"
INSTALL_HOME_MANAGER="${SETUP_HOME_MANAGER:-true}"
NIX_SYSTEM_ID="${NIX_SYSTEM_ID:-''}"

printf "SETUP_CHANNEL=$SETUP_CHANNEL; INSTALL_HOME_MANAGER=$INSTALL_HOME_MANAGER; NIX_SYSTEM_ID=$SYSTEM\n"

# get dir containing this file
FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

# Install nix package manager
if [[ -z "$(which nix-env)" ]]; then
    printf "\nnix not installed, installing..."

    # sym links nix config
    mkdir -p $HOME/.config/nix
    rm -f $HOME/.config/nix/nix.conf
    ln -s $DIR_PATH/nix.conf $HOME/.config/nix/nix.conf

    # install
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon --yes
fi

# ensure nix has been sourced
source $HOME/.nix-profile/etc/profile.d/nix.sh

# Add nixpkgs stable and unstable
if $SETUP_CHANNEL; then
    printf "\nsetting up channel https://channels.nixos.org/nixos-$VERSION..."
    # remove the default channels
    nix-channel --remove unstable
    nix-channel --remove nixpkgs

    # add specified version
    nix-channel --add "https://channels.nixos.org/nixos-$VERSION" nixpkgs
    nix-channel --update
fi

# Install home manager
if $INSTALL_HOME_MANAGER; then
    printf "\ninstalling home manager"

    # add and sync channel
    nix-channel --remove home-manager
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update

    # install home manager
    nix-shell '<home-manager>' -A install
    source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

    # setup system link, depending on system name
    rm -f $DIR_PATH/system
    if [ -z $NIX_SYSTEM_ID ]; then 
        NIX_SYSTEM_ID="$(sudo dmidecode -s system-manufacturer| awk '{print tolower($0)}')";
    fi
    printf "\nconfiguring as $NIX_SYSTEM_ID system..."
    [ "$NIX_SYSTEM_ID" == "framework" ] && ln -s $DIR_PATH/framework $DIR_PATH/system
    [ "$NIX_SYSTEM_ID" == "lenovo" ] && ln -s $DIR_PATH/lenovo $DIR_PATH/system
    [ "$NIX_SYSTEM_ID" == "google" ] && ln -s $DIR_PATH/google $DIR_PATH/system

    cd system && home-manager switch -b backup --flake .
fi

printf "\nInstall completed. Relaunch shell to use nix\n"
