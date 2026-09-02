# <img height="30" width="30" src="https://cdn.simpleicons.org/nixos/white" style="vertical-align:middle"/> Nix package manager

Install and use nix package manager to have fully reproducible libraries.

## Setting up Home Manager

Run `./install.sh` to setup nix on this computer with home manager.

Home Manager will not only install packages, but configure programs like zsh, vscode, atuin, etc.

Use `update.sh` or `cd system && home-manager switch --flake .` to update packages.

Use `home-manager expire-generations "<expire time>` to delete old home manager generations

## Store location

The store path is always `/nix`.
Nix writes that absolute path into its build results, thus a different store path makes every binary in the cache invalid, and nix builds all packages from source.

`NIX_STORE_BACKING` moves only the storage behind `/nix`, with a bind mount.
Use it when the root filesystem is disposable but a data disk is not.

```bash
NIX_STORE_BACKING=$HOME/nix ./install.sh   # keep the store on the home disk
NIX_STORE_BACKING=none ./install.sh        # keep the store on the root disk
```

A [google](google) system is a cloud VM that gets a new root disk from its image at every start.
It defaults to `$HOME/nix`.
All other systems default to a plain `/nix` on the root filesystem.

A bind mount does not survive a reboot.
See [google/README.md](google/README.md) to make it permanent on a VM.

## utils

- `bind-store.sh`: Put the nix store on persistent storage, and bind it onto /nix
- `nuke.sh`: Remove nix from system. (See https://nixos.org/manual/nix/stable/installation/uninstall)
- `remove_configs.sh`: remove all config files from system (~/.config, etc)

## systems

<div>
    <a href="lenovo"><img height="40" width="40" src="https://cdn.simpleicons.org/lenovo/white" style="vertical-align:middle"/></a>
    &nbsp;&nbsp;
    <a href="framework"><img height="30" width="30" src="https://cdn.simpleicons.org/framework/white" style="vertical-align:middle"/></a>
    &nbsp;&nbsp;
    <a href="google"><img height="30" width="30" src="https://cdn.simpleicons.org/google/white" style="vertical-align:middle"/></a>
</div>

## resources
- https://ianthehenry.com/posts/how-to-learn-nix/declarative-user-environment/
- https://cloudcrafters.cloud/blog/nix-package-manager-create-reproducible-development-environments-that-actually-work/
- https://surma.dev/things/nix-explained/
- https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableFishIntegration
