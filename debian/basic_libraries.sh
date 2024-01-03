#!/bin/bash

DOTFILES="${BASH_SOURCE%/*}/../"

# Should pull package names from Debian.yaml
ansible-playbook -b "$DOTFILES/ansible/packages.yaml" --ask-become-pass

# Update python
python -m pip install --upgrade pip wheel setuptools virtualenv

source "$DOTFILES/python/install_python.sh"
source "$DOTFILES/debian/install_firefox.sh"
source "$DOTFILES/zsh/zsh_setup.sh"
source "$DOTFILES/alacritty/install_alacritty.sh"
source "$DOTFILES/docker/install_docker.sh"
