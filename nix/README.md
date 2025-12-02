# Nix package manager

Install and use nix package manager to have fully reproducible libraries.

## install.sh

Setup nix on this computer. This uses this single user version. This will also update nix to a newer version by changing environment variable `VERSION`. 

After making any desired updates to `config.nix`, run `nix-env -iA nixpkgs.myPackages` to setup packages.

Run `nix-env -u` to update packages

To clean up old generations, run `nix-collect-garbage`

## nuke.sh

Remove nix from system.

https://nixos.org/manual/nix/stable/installation/uninstall

## Debugging

- `error: this derivation has bad 'meta.outputsToInstall'`: Run `nix-env --rollback && nix-env -irA nixpkgs.myPackages` or:
```
nix-env --list-generations
nix-env --switch-generation <generation_number>
nix-env -irA nixpkgs.myPackages
```
If that doesn't work, check if a newer version of nix exists and run `install.sh` with the new `VERSION` defined.

## TODO

- Figure out why `~/.nix-profile/etc/profile.d` deleted after `nix-env -irf pkgs.nix`
- Setup and use home manager

## Resources
- https://ianthehenry.com/posts/how-to-learn-nix/declarative-user-environment/
- https://cloudcrafters.cloud/blog/nix-package-manager-create-reproducible-development-environments-that-actually-work/
- https://surma.dev/things/nix-explained/
