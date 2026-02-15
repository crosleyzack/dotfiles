#!/bin/bash

################################################################################
# Configuration Cleanup Script for Home Manager Setup
#
# Purpose:
#   Backs up existing configuration files and removes conflicting directories
#   in preparation for a fresh home-manager installation.
#
# Behavior:
#   1. Backs up shell, git, editor, and tool configuration files by renaming
#      them with a .backup extension
#   2. Completely removes directories that conflict with home-manager
#      (oh-my-zsh, vscode, Code, etc.)
#
# Files Backed Up (renamed to *.backup):
#   - Shell configs: .zshenv, .zshrc, .bashrc, .bash_profile, .profile
#   - Git configs: .gitconfig, .config/git/config
#   - Editor configs: VSCode settings and keybindings
#   - Tool configs: tmux, starship, spaceship, atuin, gh
#
# Directories Removed:
#   - .oh-my-zsh, .vscode, .config/Code, .config/environment.d
#   - .config/tmux-powerline, home-manager state and data directories
#
# Environment Variables:
#   None
#
# WARNING:
#   This script permanently deletes directories without confirmation.
#   Review the lists carefully before running.
################################################################################

declare -a backups=(
    "$HOME/.zshenv"
    "$HOME/.zshrc"
    "$HOME/.spaceshiprc.zsh"
    "$HOME/.spaceshiprc.zsh"
    "$HOME/.gitconfig"
    "$HOME/.config/git/config"
    "$HOME/.bashrc"
    "$HOME/.bash_profile"
    "$HOME/.config/Code/User/keybindings.json"
    "$HOME/.config/Code/User/settings.json"
    "$HOME/.config/spaceship.zsh"
    "$HOME/.config/tmux/tmux.conf"
    "$HOME/.config/starship.toml"
    "$HOME/.bash_profile"
    "$HOME/.profile"
    "$HOME/.vscode/extensions"
    "$HOME/.config/atuin/config.toml"
    "$HOME/.config/gh/config.yml"
)
declare -a removes=(
    "$HOME/.oh-my-zsh"
    "$HOME/.vscode"
    "$HOME/.config/Code"
    "$HOME/.config/environment.d"
    "$HOME/.config/tmux-powerline"
    "$HOME/.local/share/home-manager"
    "$HOME/.local/state/home-manager"
)

for b in "${backups[@]}"
do
    echo "moving $b"
    mv $b "$b.backup"
done

for r in "${removes[@]}"
do
    echo "removing $r"
    rm -rf $r
done
