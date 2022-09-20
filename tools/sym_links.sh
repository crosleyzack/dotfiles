#!/bin/bash
# $1 assumed to be pull location of dotfiles repo.
CONFIG=$HOME/.config

# symbolic link:
#  ln -s target-path link-path

# Alacritty
mkdir $CONFIG/alacritty
rm $CONFIG/alacritty/alacritty.yml
echo "Linking $CONFIG/alacritty/alacritty.yml to $1/alacritty/alacritty.yml"
ln -s $1/alacritty/alacritty.yml $CONFIG/alacritty/alacritty.yml

# VS Code
mkdir $CONFIG/Code/User
rm $CONFIG/Code/User/keybindings.json
echo "Linking $CONFIG/Code/User/keybindings.json to $1/Code/User/keybindings.json"
ln -s $1/Code/User/keybindings.json $CONFIG/Code/User/keybindings.json
rm $CONFIG/Code/User/settings.json
echo "Linking $CONFIG/Code/User/settings.json to $1/Code/User/settings.json"
ln -s $1/Code/User/settings.json $CONFIG/Code/User/settings.json

# Tmux
mkdir $CONFIG/tmux
rm $CONFIG/tmux/tmux.conf
echo "Linking $CONFIG/tmux/tmux.conf to $1/tmux/tmux.conf"
ln -s $1/tmux/tmux.conf $CONFIG/tmux/tmux.conf

#Zsh
rm $HOME/.zshrc
echo "Linking $HOME/.zshrc to $1/zsh/zshrc"
ln -s $1/zsh/zshrc $HOME/.zshrc

# Docker
sudo rm /etc/docker/daemon.json
echo "Linking /etc/docker/deamon.json to $1/docker/daemon.json"
sudo ln -s $1/docker/daemon.json /etc/docker/daemon.json

# Tmux
mkdir $CONFIG/tmux
rm $CONFIG/tmux/tmux.conf
echo "Linking $HOME/.ghc/ghci.conf to $1/haskell/ghci.conf"
ln -s $1/haskell/ghci.conf $HOME/.ghc/ghci.conf
chmod go-w $HOME/.ghc
chmod go-w $1/haskell/ghci.conf
