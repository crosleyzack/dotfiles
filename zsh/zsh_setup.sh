#!/bin/bash
# Runs even if Zsh isn't already installed

# Install zsh, if it isn't already.
source "${BASH_SOURCE%/*}/../tools/install_tools.sh"
is_installed zsh
if [ "false" = "$INSTALLED" ]
then
    # ansible localhost -m ansible.builtin.package -a "name=zsh state=latest"
    sudo apt install zsh
fi

# set XDG_CONFIG_HOME if not defined
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME-$HOME/.config}

# define this directory
CONFIG_DIR="$HOME/dev/dotfiles/zsh"

# Move ZSH history and config
# TODO move to $XDG_CONFIG_HOME/zsh
export ZDOTDIR=$HOME
export HISTFILE=$ZOTDIR/.zsh_record
export ZSH=$ZDOTDIR/.oh-my-zsh

# Setup oh my zsh
rm -rf $ZSH
git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH
chmod u+x $ZSH/oh-my-zsh.sh

# Make ZSH default shell.
chsh -s $(which zsh)

# define custom plugin locations
if [[ -z "${ZSH_CUSTOM}" ]]; then
    ZSH_CUSTOM="$ZSH/custom"
fi
mkdir -p "$ZSH_CUSTOM"

# Setup ZSH src - TODO, do not hardcode path
rm -f $ZDOTDIR/.zshrc
echo "Linking $ZDOTDIR/.zshrc to $CONFIG_DIR/zshrc"
ln -s $CONFIG_DIR/zshrc $ZDOTDIR/.zshrc

# Setup zsh env
rm -f $ZDOTDIR/.zshenv
echo "Linking $ZDOTDIR/.zshenv to $CONFIG_DIR/zshenv"
ln -s $CONFIG_DIR/zshenv $ZDOTDIR/.zshenv

# Install spaceship prompt
rm -rf "$ZSH_CUSTOM/themes/spaceship-prompt"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# setup spaceship config
rm -rf "$ZDOTDIR/spaceship.zsh"
ln -sf "$CONFIG_DIR/spaceship.zsh" "$ZDOTDIR/spaceship.zsh"

# Install spaceship vi
rm -rf "$ZSH_CUSTOM/plugins/spaceship-vi-mode"
git clone https://github.com/spaceship-prompt/spaceship-vi-mode.git "$ZSH_CUSTOM/plugins/spaceship-vi-mode"

# Install zsh-syntax-highlighting
rm -rf "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# Install autosuggestions
rm -rf "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

# install toolbox
# mkdir -p "$HOME/.zsh"
# git clone --depth=1 https://github.com/CrosleyZack/spaceship-toolbox.git "$HOME/.zsh/spaceship-toolbx"

# sym link
# mkdir -p $HOME/.oh-my-zsh
# ln -s $ZSH/oh-my-zsh.sh $HOME/.oh-my-zsh/oh-my-zsh.sh
