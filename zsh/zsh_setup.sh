#!/bin/bash
# Runs even if Zsh isn't already installed

# Install zsh, if it isn't already.
sudo apt install zsh

# If ZSH isn't set, use default
if [[ -z "${ZSH}" ]]; then
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    ZSH="$SCRIPT_DIR/oh-my-zsh"
fi
mkdir -p "$ZSH"
if [[ -z "${ZSH_CUSTOM}" ]]; then
    ZSH_CUSTOM="$ZSH/custom"
fi
mkdir -p "$ZSH_CUSTOM"

# Setup oh my zsh
rm -rf $ZSH
git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"

# Make ZSH default shell.
chsh -s $(which zsh)

# Setup ZSH src - TODO, do not hardcode path
rm -f $HOME/.zshrc
echo "Linking $HOME/.zshrc to $HOME/dev/dotfiles/zsh/zshrc"
ln -s $HOME/dev/dotfiles/zsh/zshrc $HOME/.zshrc
# Install spaceship prompt
rm -rf "$ZSH_CUSTOM/themes/spaceship-prompt"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Install spaceship vi
rm -rf "$ZSH_CUSTOM/plugins/spaceship-vi-mode"
git clone https://github.com/spaceship-prompt/spaceship-vi-mode.git "$ZSH_CUSTOM/plugins/spaceship-vi-mode"
