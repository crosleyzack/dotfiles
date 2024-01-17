#!/bin/bash

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.podman_desktop.PodmanDesktop
flatpak install flathub org.gimp.GIMP
flatpak install flathub com.spotify.Client
flatpak install flathub com.slack.Slack
flatpak install flathub org.signal.Signal
# flatpak install flathub com.visualstudio.code
flatpak install flathub com.bitwarden.desktop
# flatpak install flathub io.neovim.nvim
# flatpak install flathub org.mozilla.firefox
