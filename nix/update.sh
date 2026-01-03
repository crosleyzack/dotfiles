#!/bin/bash

FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

if [ ! -L $DIR_PATH/system ]; then
    echo "system not found, run `ln -s <flake dir> system` with correct directory"
    exit 1
fi

nix-channel --update

# home-manager switch 
cd $DIR_PATH/system && home-manager switch -b backup --flake .
