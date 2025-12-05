#!/bin/bash

# completely remove nix, mostly for testing setup
# https://nix.dev/manual/nix/2.32/installation/uninstall.html

echo "stopping nix daemon"
sudo systemctl stop nix-daemon.service
sudo systemctl disable nix-daemon.socket nix-daemon.service
sudo systemctl daemon-reload

echo "removing all nix files"
sudo rm -rf /etc/nix /etc/profile.d/nix.sh /etc/tmpfiles.d/nix-daemon.conf /nix ~root/.nix-channels ~root/.nix-defexpr ~root/.nix-profile ~root/.cache/nix /usr/share/osinfo/os/nixos.org ~/.local/state/nix ~/.cache/nix ~/.config/nixpkg ~/.config/nixpkgs ~/.config/nix ~/.config/home-manager ~/.nix-defexpr ~/.nix-profile ~/.nix-channels /nix ~/.local/share/home-manager ~/.local/state/home-manager /tmp/nix-shell-*

echo "removing nix users"
for i in $(seq 1 32); do
  sudo userdel nixbld$i
done
sudo groupdel nixbld
