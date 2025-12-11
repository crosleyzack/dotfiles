#!/bin/bash

FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

if [ ! -f $DIR_PATH/home.nix ]; then
    echo "home.nix not found, run `ln -s <file>.nix home.nix` with correct file"
    exit 1
fi

nix-channel --update

rm -f $HOME/.config/home-manager/home.nix
rm -rf $HOME/.config/home-manager/home
cp -L $DIR_PATH/home.nix $HOME/.config/home-manager/home.nix
cp -Lr $DIR_PATH/home $HOME/.config/home-manager/home
# this file tends to cause problems, remove it
rm $HOME/.config/atuin/config.toml

home-manager switch
