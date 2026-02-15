#!/bin/bash

################################################################################
# Snap Application Installation Script
#
# Purpose:
#   Installs a curated set of applications using Snap package manager.
#
# Behavior:
#   1. Verifies snap is installed
#   2. Iterates through a predefined list of applications and installs each one
#
# Applications Installed:
#   - Slack (team communication)
#   - Spotify (music streaming)
#   - Obsidian (note-taking)
#   - Proton Pass (password manager)
#   - Beekeeper Studio (database client)
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - snap installed
#   - Sudo privileges
################################################################################

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
