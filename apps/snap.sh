#!/bin/bash

if [[ -z "$(which snap)" ]]; then
    echo "snap not installed"
    exit 1
fi

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

declare -a packages=(
    "slack"
    "spotify"
    "proton-pass"
    "obsidian"
)

## now loop through the above array
for i in "${packages[@]}"
do
    sudo snap install $i
done
