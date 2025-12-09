#!/bin/bash

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
