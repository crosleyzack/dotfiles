#!/bin/bash

################################################################################
# Nix Complete Removal Script
#
# Purpose:
#   Completely removes Nix package manager and all associated files, users,
#   and configurations from the system. Primarily used for testing fresh
#   installations.
#
# Behavior:
#   1. Stops and disables the nix-daemon systemd service
#   2. Removes all Nix files and directories from system and user locations:
#      - /nix store and configuration
#      - System-wide Nix configs (/etc/nix, /etc/profile.d/nix.sh, etc.)
#      - User Nix profiles, channels, and cache
#      - home-manager state and data
#   3. Deletes Nix build users (nixbld1-nixbld32) and the nixbld group
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - Sudo privileges
#
# WARNING:
#   This is a DESTRUCTIVE operation that permanently removes ALL Nix
#   installations, packages, profiles, and configurations. There is NO
#   confirmation prompt. Use with extreme caution.
#
# Reference:
#   https://nix.dev/manual/nix/2.32/installation/uninstall.html
################################################################################

# completely remove nix, mostly for testing setup
# https://nix.dev/manual/nix/2.32/installation/uninstall.html

echo "stopping nix daemon"
sudo systemctl stop nix-daemon.service
sudo systemctl disable nix-daemon.socket nix-daemon.service
sudo systemctl daemon-reload

echo "removing all nix files"
sudo rm -rf /etc/nix /etc/profile.d/nix.sh /etc/tmpfiles.d/nix-daemon.conf /nix ~root/.nix-channels ~root/.nix-defexpr ~root/.nix-profile ~root/.cache/nix /usr/share/osinfo/os/nixos.org $HOME/.local/state/nix $HOME/.cache/nix $HOME/.config/nixpkg $HOME/.config/nixpkgs $HOME/.config/nix $HOME/.config/home-manager $HOME/.nix-defexpr $HOME/.nix-profile $HOME/.nix-channels /nix $HOME/.local/share/home-manager $HOME/.local/state/home-manager /tmp/nix-shell-*

echo "removing nix users"
for i in $(seq 1 32); do
  sudo userdel nixbld$i
done
sudo groupdel nixbld
