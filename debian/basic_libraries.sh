#!/bin/bash

DOTFILES="${BASH_SOURCE%/*}/../"

ansible-playbook -b "$DOTFILES/ansible/install_packages.yml"

# Update python
python -m pip install --upgrade pip wheel setuptools virtualenv

source "$DOTFILES/python/install_python.sh"
source "$DOTFILES/debian/install_firefox.sh"
source "$DOTFILES/zsh/zsh_setup.sh"
source "$DOTFILES/alacritty/install_alacritty.sh"
source "$DOTFILES/docker/install_docker.sh"
