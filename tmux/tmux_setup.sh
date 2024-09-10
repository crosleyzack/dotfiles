#!/bin/bash

PLUGINS_DIR="$HOME/.config/tmux/plugins"
rm -rf $PLUGINS_DIR
mkdir -p $PLUGINS_DIR
git clone https://github.com/tmux-plugins/tpm $PLUGINS_DIR/tpm
git clone https://github.com/tmux-plugins/tmux-resurrect $PLUGINS_DIR/resurrect
git clone https://github.com/tmux-plugins/tmux-continuum $PLUGINS_DIR/continuum
git clone https://github.com/erikw/tmux-powerline.git $PLUGINS_DIR/powerline
git clone git@github.com:rickstaa/tmux-notify.git $PLUGINS_DIR/notify
git clone git@github.com:MunifTanjim/tmux-mode-indicator.git $PLUGINS_DIR/indicator
git clone git@github.com:tmux-plugins/tmux-yank.git $PLUGINS_DIR/yank
