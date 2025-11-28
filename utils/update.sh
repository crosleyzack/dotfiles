#!/bin/bash

# Script to update machine fully

FILE="${BASH_SOURCE%/*}"
source "$FILE/../utils/installed.sh"

# Apt packages
is_installed apt
if [ "true" = "$INSTALLED" ]
then
    sudo apt update
    sudo apt dist-upgrade
    sudo apt autoremove
    sudo apt autoclean
    sudo apt clean
fi

# dnf packages
is_installed dnf
if [ "true" = "$INSTALLED" ]
then
    sudo dnf upgrade
    sudo dnf distro-sync
fi

# ansible
is_installed ansible
if [ "true" = "$INSTALLED" ]
then
    ansible-playbook -b "$FILE/../ansible/packages.yaml" --ask-become-pass
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
fi

# update snap
is_installed snap
if [ "true" = "$INSTALLED" ]
then
    sudo snap refresh
fi

# update nix
is_installed nix-channel
if [ "true" = "$INSTALLED" ]
then
    nix-channel --update
    # nix-collect-garbage -d
fi

# update flatpak
is_installed flatpak
if [ "true" = "$INSTALLED" ]
then
    flatpak update
fi

# update vscode extensions
is_installed code
if [ "true" = "$INSTALLED" ]
then
    code --update-extensions
fi

# update omz
is_installed omz
if [ "true" = "$INSTALLED" ]
then
    omz update
fi

# update atuin-update
is_installed atuin-update
if [ "true" = "$INSTALLED" ]
then
    atuin-update
fi
