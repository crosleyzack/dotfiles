#!/bin/bash

# Script to update machine fully

source "${BASH_SOURCE%/*}/../tools/install_tools.sh"

# Apt packages
is_installed apt
if [ "true" = "$INSTALLED" ]
then
    sudo apt update
    sudo apt upgrade
    sudo apt autoremove
    sudo apt autoclean
    sudo apt clean
fi

# Update rust
is_installed rustup
if [ "true" = "$INSTALLED" ]
then
    rustup update
fi

# Update brew
is_installed brew
if [ "true" = "$INSTALLED" ]
then
    brew update
    brew upgrade
fi

# Update important python libs
is_installed python
if [ "true" = "$INSTALLED" ]
then
    python -m pip install --upgrade wheel pip setuptools virtualenv
    cd ~/.pyenv && git pull
fi

# update snap
is_installed snap
if [ "true" = "$INSTALLED" ]
then
    sudo snap refresh
fi

# update nix
is_installed home-manager
if [ "true" = "$INSTALLED" ]
then
    nix-channel --update
    home-manager switch
fi
