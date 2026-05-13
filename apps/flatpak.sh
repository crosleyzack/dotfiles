#!/bin/bash

################################################################################
# Flatpak Application Installation Script
#
# Purpose:
#   Installs a curated set of applications from Flathub using Flatpak.
#
# Behavior:
#   1. Verifies flatpak is installed
#   2. Adds Flathub repository if not already present
#   3. Iterates through a predefined list of applications and installs each one
#
# Applications Installed:
#   - Podman Desktop (container management)
#   - GIMP (image editing)
#   - Spotify (music streaming)
#   - Signal (secure messaging)
#   - Proton Mail (email client)
#   - Proton Pass (password manager)
#   - Obsidian (note-taking)
#   - Steam (gaming platform)
#   - LibreCAD (CAD application)
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - flatpak installed
################################################################################

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
    "com.yubico.yubioath"
)

## now loop through the above array
for i in "${packages[@]}"
do
    flatpak install flathub $i
done
