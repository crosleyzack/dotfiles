#!/bin/bash
# $BASE_DIR assumed to be pull location of dotfiles repo.
CONFIG=$HOME/.config

# Ensure dotfiles repo is defined
if [ -z "$1" ]
then
      echo "\$1 must be dotfiles directory"
      exit 1
fi

# symbolic link:
#  ln -s target-path link-path

BASE_DIR=$(realpath $1)

# Bash
rm -f ~/.bashrc
echo "Linking $HOME/.bashrc to $BASE_DIR/bash/.bashrc"
ln -s $BASE_DIR/bash/.bashrc $HOME/.bashrc

# Alacritty
mkdir -p $CONFIG/alacritty
rm -f $CONFIG/alacritty/alacritty.toml
echo "Linking $CONFIG/alacritty/alacritty.toml to $BASE_DIR/alacritty/alacritty.toml"
ln -s $BASE_DIR/alacritty/alacritty.toml $CONFIG/alacritty/alacritty.toml

# VS Code
mkdir -p $CONFIG/Code/User
rm -f $CONFIG/Code/User/keybindings.json
echo "Linking $CONFIG/Code/User/keybindings.json to $BASE_DIR/Code/User/keybindings.json"
ln -s $BASE_DIR/Code/User/keybindings.json $CONFIG/Code/User/keybindings.json
rm -f $CONFIG/Code/User/settings.json
echo "Linking $CONFIG/Code/User/settings.json to $BASE_DIR/Code/User/settings.json"
ln -s $BASE_DIR/Code/User/settings.json $CONFIG/Code/User/settings.json

# Tmux
mkdir -p $HOME/.config/tmux
rm -f $HOME/.config/tmux/tmux.conf
echo "Linking $HOME/.config/tmux/tmux.conf to $BASE_DIR/tmux/tmux.conf"
ln -s $BASE_DIR/tmux/tmux.conf $HOME/.config/tmux/tmux.conf

# Zsh
rm -f $HOME/.zshrc
echo "Linking $HOME/.zshrc to $BASE_DIR/zsh/zshrc"
ln -s $BASE_DIR/zsh/zshrc $HOME/.zshrc
rm -f $HOME/.zshenv
echo "Linking $HOME/.zshenv to $BASE_DIR/zsh/zshenv"
ln -s $BASE_DIR/zsh/zshenv $HOME/.zshenv

# Spaceship Prompt
rm -f $HOME/.config/spaceship.zsh
echo "Linking $HOME/.config/spaceship.zsh to $BASE_DIR/zsh/spaceship.zsh"
ln -s $BASE_DIR/zsh/spaceship.zsh $HOME/.config/spaceship.zsh

# Docker
sudo rm -f /etc/docker/daemon.json
sudo mkdir -p /etc/docker
echo "Linking /etc/docker/deamon.json to $BASE_DIR/docker/daemon.json"
sudo ln -s $BASE_DIR/docker/daemon.json /etc/docker/daemon.json

# GHC
mkdir -p $HOME/.ghc
rm -f $HOME/.ghc/ghci.conf
echo "Linking $HOME/.ghc/ghci.conf to $BASE_DIR/haskell/ghci.conf"
ln -s $BASE_DIR/haskell/ghci.conf $HOME/.ghc/ghci.conf
chmod go-w $HOME/.ghc
chmod go-w $BASE_DIR/haskell/ghci.conf

# Proxychains
mkdir -p $HOME/.proxychains/
rm -f $HOME/.proxychains/proxychains.conf
echo "Linking $HOME/.proxychains/proxychains.conf to $BASE_DIR/proxychains/proxychains.conf"
ln -s $BASE_DIR/proxychains/proxychains.conf $HOME/.proxychains/proxychains.conf

# PulseAudio
mkdir -p $HOME/.config/pulse/
rm -f $HOME/.config/pulse/default.pa
echo "Linking $HOME/.config/pulse/default.pa to $BASE_DIR/pulse/default.pa"
ln -s $BASE_DIR/pulse/default.pa $HOME/.config/pulse/default.pa

# Gitconfig - We actually copy this one so that we can change the user name!
rm -f $HOME/.gitconfig
echo "copying $BASE_DIR/git/.gitconfig to $HOME/.gitconfig"
cp $BASE_DIR/git/.gitconfig $HOME/.gitconfig

# Vim
rm -f $HOME/.vimrc
echo "Linking $HOME/.vimrc to $BASE_DIR/vim/.vimrc"
ln -s $BASE_DIR/vim/.vimrc $HOME/.vimrc
mkdir -p $HOME/.vim
rm -rf $HOME/.vim/colors
echo "Linking $HOME/.vim/colors to $BASE_DIR/vim/colors"
ln -s $BASE_DIR/vim/colors $HOME/.vim/colors

# Nvim
rm -f $HOME/.config/nvim/init.vim
echo "Linking $HOME/.config/nvim/init.vim to $BASE_DIR/nvim/init.vim"
mkdir -p $HOME/.config/nvim
ln -s $BASE_DIR/nvim/init.vim $HOME/.config/nvim/init.vim

# Nix
sudo rm -f /etc/nix/nix.conf
echo "Linking /etc/nix/nix.conf to $BASE_DIR/nix/nix.conf"
sudo mkdir -p /etc/nix/
sudo ln -s $BASE_DIR/nix/nix.conf /etc/nix/nix.conf

# Nix conf
sudo rm -f $HOME/.config/nix/nix.conf
echo "Linking $HOME/.config/nix/nix.conf to $BASE_DIR/nix/nix.conf"
sudo mkdir -p $HOME/.config/nix
sudo ln -s $BASE_DIR/nix/nix.conf $HOME/.config/nix/nix.conf

# Nixpkgs conf
sudo rm -f $HOME/.config/nixpkgs/config.nix
echo "Linking $HOME/.config/nixpkgs/config.nix to $BASE_DIR/nix/config.nix"
sudo mkdir -p $HOME/.config/nixpkgs
sudo ln -s $BASE_DIR/nix/config.nix $HOME/.config/nixpkgs/config.nix

# nix home manager
# sudo rm -f $HOME/.config/home-manager/home.nix
# echo "Linking $HOME/.config/home-manager/home.nix to $BASE_DIR/nix/home.nix"
# sudo mkdir -p $HOME/.config/home-manager
# sudo ln -s $BASE_DIR/nix/home.nix $HOME/.config/home-manager/home.nix

# distrobox
sudo rm -f $HOME/distrobox.ini
echo "Linking $HOME/distrobox.ini to $BASE_DIR/distrobox/distrobox.ini"
sudo ln -s $BASE_DIR/distrobox/distrobox.ini $HOME/distrobox.ini
sudo rm -f $HOME/.config/distrobox/distrobox.conf
sudo mkdir -p $HOME/.config/distrobox
echo "Linking $HOME/.config/distrobox/distrobox.conf to $BASE_DIR/distrobox/distrobox.conf"
sudo ln -s $BASE_DIR/distrobox/distrobox.conf $HOME/.config/distrobox/distrobox.conf

