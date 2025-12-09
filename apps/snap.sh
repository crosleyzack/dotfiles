#!/bin/bash

if [[ -z "$(which snap)" ]]; then
    echo "snap not installed"
    exit 1
fi

declare -a packages=(
    "slack"
    "spotify"
    "obsidian"
    "proton-pass"
    "beekeeper-studio"
)

## now loop through the above array
for i in "${packages[@]}"
do
    sudo snap install $i
done
