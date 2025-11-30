# Nix package manager

Install and use nix package manager to have fully reproducible libraries.

## install.sh

Setup nix on this computer. This uses this single user version. This will also update nix to a newer version by changing environment variable `VERSION`. 

After making any desired updates to `pkgs.nix`, run `nix-env -i -f pkgs.nix` to setup packages.

Run `nix-env -u` to update packages

To clean up old generations, run `nix-collect-garbage`

## nuke.sh

Remove nix from system.

https://nixos.org/manual/nix/stable/installation/uninstall

## Debugging

- `error: this derivation has bad 'meta.outputsToInstall'`: Run `nix-env --rollback && nix-env -i -f pkgs.nix` or:
```
nix-env --list-generations
nix-env --switch-generation <generation_number>
nix-env -i -f pkgs.nix
```
If that doesn't work, check if a newer version of nix exists and run `install.sh` with the new `VERSION` defined.

## TODO

Setup and use home manager
