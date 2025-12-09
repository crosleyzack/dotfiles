#!/bin/bash

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
