#!/bin/bash

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

declare -a packages=(
    "io.podman_desktop.PodmanDesktop"
    "org.gimp.GIMP"
    "com.spotify.Client"
    "com.slack.Slack"
    "org.signal.Signal"
    "me.proton.Mail"
    "me.proton.Pass"
    "md.obsidian.Obsidian"
    "app.zen_browser.zen"
)

## now loop through the above array
for i in "${packages[@]}"
do
    flatpak install flathub $i
done

