#!/bin/bash

if [[ -z "$(which flatpak)" ]]; then
    echo "flatpak not installed"
    exit 1
fi

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

declare -a packages=(
    "io.podman_desktop.PodmanDesktop"
    "org.gimp.GIMP"
    "com.spotify.Client"
    "org.signal.Signal"
    "me.proton.Mail"
    "me.proton.Pass"
    "md.obsidian.Obsidian"
    "com.valvesoftware.Steam"
    "org.librecad.librecad"
)

## now loop through the above array
for i in "${packages[@]}"
do
    flatpak install flathub $i
done
