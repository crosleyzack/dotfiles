#!/bin/bash
# NOTE: requires ZSH be already installed

# set XDG_CONFIG_HOME if not defined
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME-$HOME/.config}

# define this directory
CONFIG_DIR=$HOME/dev/dotfiles/zsh

# Move ZSH history and config
# TODO move to $XDG_CONFIG_HOME/zsh
export ZDOTDIR=${ZDOTDIR-$HOME}
echo "ZDOTDIR=$ZDOTDIR"
export HISTFILE=$ZDOTDIR/.zsh_record
echo "HISTFILE=$HISTFILE"
export ZSH=$ZDOTDIR/.oh-my-zsh
echo "ZSH=$ZSH"
export ZSH_CUSTOM=$ZSH/custom
echo "ZSH_CUSTOM=$ZSH_CUSTOM"

read -p "Continue? (Y/N): " confirm && [[ $confirm == [nN] || $confirm == [nN][oO] ]] && exit

# Setup oh my zsh
rm -rf $ZSH
git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH
chmod u+x $ZSH/oh-my-zsh.sh

# Make ZSH default shell.
chsh -s $(which zsh)

# Setup ZSH src - TODO, do not hardcode path
rm -f $ZDOTDIR/.zshrc
echo "Linking $ZDOTDIR/.zshrc to $CONFIG_DIR/zshrc"
ln -s $CONFIG_DIR/zshrc $ZDOTDIR/.zshrc

# Setup zsh env
rm -f $ZDOTDIR/.zshenv
echo "Linking $ZDOTDIR/.zshenv to $CONFIG_DIR/zshenv"
ln -s $CONFIG_DIR/zshenv $ZDOTDIR/.zshenv

# Install spaceship prompt
mkdir -p $ZSH_CUSTOM
rm -rf $ZSH_CUSTOM/themes/spaceship-prompt
git clone https://github.com/spaceship-prompt/spaceship-prompt.git $ZSH_CUSTOM/themes/spaceship-prompt --depth=1
ln -sf $ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme $ZSH_CUSTOM/themes/spaceship.zsh-theme

# setup spaceship config
rm -rf $ZDOTDIR/.spaceshiprc.zsh
ln -sf $CONFIG_DIR/spaceship.zsh $ZDOTDIR/.spaceshiprc.zsh

# Install spaceship vi
rm -rf $ZSH_CUSTOM/plugins/spaceship-vi-mode
git clone https://github.com/spaceship-prompt/spaceship-vi-mode.git $ZSH_CUSTOM/plugins/spaceship-vi-mode

# Install zsh-syntax-highlighting
rm -rf $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Install autosuggestions
rm -rf $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# setup atuin
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# install toolbox
# mkdir -p "$HOME/.zsh"
# git clone --depth=1 https://github.com/CrosleyZack/spaceship-toolbox.git "$HOME/.zsh/spaceship-toolbx"

# sym link
# mkdir -p $HOME/.oh-my-zsh
# ln -s $ZSH/oh-my-zsh.sh $HOME/.oh-my-zsh/oh-my-zsh.sh
