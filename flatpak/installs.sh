#!/bin/bash

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

declare -a packages=(
    "io.podman_desktop.PodmanDesktop"
    "org.gimp.GIMP"
    "com.spotify.Client"
    "com.slack.Slack"
    "org.signal.Signal"
    "com.bitwarden.desktop"
    "md.obsidian.Obsidian"
)
# com.usebruno.Bruno
# com.visualstudio.code
# io.neovim.nvim
# org.mozilla.firefox
# us.zoom.Zoom
# https://github.com/flathub/us.zoom.Zoom/issues/437
# flatpak update --commit=786cd52f8219276edd0184f3c6fa0ca7041c3814369fe378dc068a0864b049a9 us.zoom.Zoom
# flatpak mask us.zoom.Zoom

## now loop through the above array
for i in "${packages[@]}"
do
    flatpak install flathub $i
done

