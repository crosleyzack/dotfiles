# Nix package manager

Install and use nix package manager to have fully reproducible libraries.

Run `install.sh` to setup nix on this computer. This uses this single user version.

After making any desired updates to `pkgs.nix`, run `nix-env -i -f pkgs.nix` to setup packages.

Run `nix-env -u` to update packages

To clean up old generations, run `nix-collect-garbage`

## nuke.sh

Remove nix from system.

https://nixos.org/manual/nix/stable/installation/uninstall

## TODO

Setup and use home manager
