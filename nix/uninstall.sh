#!/bin/bash

rm -rf /nix/
rm -rf ~/.nix-channels ~/.nix-defexpr ~/.nix-profile
sudo rm -rf /etc/nix /etc/profile.d/nix.sh /etc/tmpfiles.d/nix-daemon.conf /nix ~root/.nix-channels ~root/.nix-defexpr ~root/.nix-profile


sudo systemctl stop nix-daemon.service
sudo systemctl disable nix-daemon.socket nix-daemon.service
sudo systemctl daemon-reload

for i in $(seq 1 32); do
  sudo userdel nixbld$i
done
sudo groupdel nixbld
