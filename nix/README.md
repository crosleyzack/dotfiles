# Nix package manager

Install and use nix package manager and home manager to get newer library versions than are available on debian, as well as have these configurations be fully reproducible.

After changing `home.nix`, run `home-manager switch`

To clean up old generations, run:
```
nix-collect-garbage
```

## install_nix.sh

Setup nix package manager and home manager.

## uninstall.sh

Remove nix from system.

https://nixos.org/manual/nix/stable/installation/uninstall

## config.nix

Settings for nix package manager

## home.nix

Settings for nix home manager

## others

Works in progress
