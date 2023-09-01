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

# Alacritty
mkdir -p $CONFIG/alacritty
rm -f $CONFIG/alacritty/alacritty.yml
echo "Linking $CONFIG/alacritty/alacritty.yml to $BASE_DIR/alacritty/alacritty.yml"
ln -s $BASE_DIR/alacritty/alacritty.yml $CONFIG/alacritty/alacritty.yml

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

#Zsh
rm -f $HOME/.zshrc
echo "Linking $HOME/.zshrc to $BASE_DIR/zsh/zshrc"
ln -s $BASE_DIR/zsh/zshrc $HOME/.zshrc

# Docker
sudo rm -f /etc/docker/daemon.json
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
