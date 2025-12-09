#!/bin/bash
CONFIG=$HOME/.config
FILE_PATH=$(realpath $BASH_SOURCE)
BASE_DIR=$(dirname $FILE_PATH)

# VS Code
mkdir -p $CONFIG/Code/User
rm -f $CONFIG/Code/User/keybindings.json
echo "Linking $CONFIG/Code/User/keybindings.json to $BASE_DIR/User/keybindings.json"
ln -s $BASE_DIR/User/keybindings.json $CONFIG/Code/User/keybindings.json
rm -f $CONFIG/Code/User/settings.json
echo "Linking $CONFIG/Code/User/settings.json to $BASE_DIR/User/settings.json"
ln -s $BASE_DIR/User/settings.json $CONFIG/Code/User/settings.json
