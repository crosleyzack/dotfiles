#!/bin/bash

################################################################################
# Universal System Update Script
#
# Purpose:
#   Performs a comprehensive system update across all installed package
#   managers, programming language toolchains, and application frameworks.
#
# Behavior:
#   Detects and updates all available package managers and tools on the system:
#
#   Package Managers:
#   - apt (Debian/Ubuntu): update, dist-upgrade, autoremove, clean
#   - dnf (Fedora/RHEL): upgrade, distro-sync
#   - snap: refresh all snaps
#   - flatpak: update all flatpaks
#   - nix: update channels (with optional garbage collection)
#   - homebrew: update formulae and casks
#
#   Development Tools:
#   - rustup: update Rust toolchain
#   - python pip: upgrade pip, wheel, setuptools, virtualenv
#
#   Configuration Management:
#   - ansible: run packages playbook
#   - home-manager: switch to latest configuration
#
#   Applications:
#   - vscode: update all extensions
#   - oh-my-zsh: update framework and plugins
#   - atuin: update shell history tool
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - Sudo privileges (required for system package managers)
#   - Individual tools must be installed for their respective updates
#
# Note:
#   This script is safe to run on any system - it only updates tools that
#   are actually installed. Missing tools are silently skipped.
################################################################################

# Script to update machine fully
FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

# Apt packages
if [ -x "$(command -v apt)" ]; then
    sudo apt update
    sudo apt dist-upgrade --yes
    sudo apt autoremove
    sudo apt autoclean
    sudo apt clean
fi

# dnf packages
if [ -x "$(command -v dnf)" ]; then
    sudo dnf upgrade -y
    sudo dnf distro-sync
fi

# ansible
if [ -x "$(command -v ansible)" ]; then
    ansible-playbook -b "$FILE/../ansible/packages.yaml" --ask-become-pass
fi

# Update rust
if [ -x "$(command -v rustup)" ]; then
    rustup update
fi

# Update brew
if [ -x "$(command -v brew)" ]; then
    brew update
    brew upgrade
fi

# Update important python libs
if [ -x "$(command -v python)" ]; then
    python -m pip install --upgrade wheel pip setuptools virtualenv
fi

# update snap
if [ -x "$(command -v snap)" ]; then
    sudo snap refresh
fi

# update nix
if [ -x "$(command -v nix-channel)" ]; then
    nix-channel --update
    # run periodically
    # nix-collect-garbage -d
fi

# home manager update
if [ -x "$(command -v home-manager)" ]; then
    bash $DIR_PATH/../nix/update.sh
fi

# update flatpak
if [ -x "$(command -v flatpak)" ]; then
    flatpak update
fi

# update vscode extensions
if [ -x "$(command -v code)" ]; then
    code --update-extensions
fi

# update omz
if [ -x "$(command -v omz)" ]; then
    omz update
fi

# update atuin-update
if [ -x "$(command -v atuin-update)" ]; then
    atuin-update
fi
