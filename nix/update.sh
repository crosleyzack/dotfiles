#!/bin/bash

FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

echo "Make sure the home directory is correct and vscode is disabled if on Ubuntu"
read -p "Do you want to continue? (y/n) " yn

case $yn in
    y ) echo ok, we will proceed;;
    n ) echo exiting...;
        exit;;
    * ) echo invalid response;
        exit 1;;
esac

rm -f $HOME/.config/home-manager/home.nix
rm -rf $HOME/.config/home-manager/home
cp -L $DIR_PATH/home.nix $HOME/.config/home-manager/home.nix
cp -Lr $DIR_PATH/home $HOME/.config/home-manager/home
# this file tends to cause problems, remove it
rm $HOME/.config/atuin/config.toml

nix-channel --update
home-manager switch
