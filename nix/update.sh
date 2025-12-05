#!/bin/bash

FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

rm -f $HOME/.config/home-manager/home.nix
rm -rf $HOME/.config/home-manager/home
cp $DIR_PATH/home.nix $HOME/.config/home-manager/home.nix
cp -r $DIR_PATH/home $HOME/.config/home-manager/home

home-manager switch
