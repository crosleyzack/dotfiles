# Nix package manager

Install and use nix package manager to have fully reproducible libraries.

## Setting up barebones Nix

Run `SETUP_CHANNEL=true INSTALL_HOME_MANAGER=false INSTALL_NIX_PKGS=true ./install.sh` to setup nix on this computer without home manager.

This uses this single user version. This will also update nix to a newer version by changing environment variable `VERSION`. 

After making any desired updates to `config.nix`, run `nix-env -iA nixpkgs.myPackages` to setup packages.

Run `nix-env -u` to update packages

To clean up old generations, run `nix-collect-garbage`

## Setting up Home Manager

Run `SETUP_CHANNEL=true INSTALL_HOME_MANAGER=true INSTALL_NIX_PKGS=false ./install.sh` to setup nix on this computer with home manager.

Home Manager will not only install packages, but configure programs like zsh, vscode, atuin, etc.

Use `home-manager switch` to update packages.

Use `home-manager expire-generations "<expire time>` to delete old home manager generations

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

## Resources
- https://ianthehenry.com/posts/how-to-learn-nix/declarative-user-environment/
- https://cloudcrafters.cloud/blog/nix-package-manager-create-reproducible-development-environments-that-actually-work/
- https://surma.dev/things/nix-explained/
- https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableFishIntegration
