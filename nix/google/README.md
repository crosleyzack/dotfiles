# <img height="30" width="30" src="https://cdn.simpleicons.org/google/white" style="vertical-align:middle"/> Google VM

Nix configuration for Google VM system

This VM gets a new root disk from its image at every start.
Only the data disk that it mounts at `/home` survives.
Thus the nix store must sit on that disk, or home manager disappears with each new instance.

## Store persistence

The store path stays `/nix`, and `/nix` becomes a bind mount of `$HOME/nix`.
See [Store location](../README.md#store-location) for why the path must not change.

`install.sh` does this without configuration on this system, because `NIX_STORE_BACKING` defaults to `$HOME/nix` when `NIX_SYSTEM_ID` is `google`.

```bash
NIX_SYSTEM_ID=google ~/dev/dotfiles/nix/install.sh
```

If the VM already holds a store on the root disk, the same command moves it to the data disk first.
It keeps a copy at `/nix.pre-bind` until you delete it.

## Boot

A bind mount does not survive a reboot, and `/etc/fstab` is on the root disk.
Give [startup-script.sh](startup-script.sh) to the instance as metadata, thus the VM restores the mount at every boot:

```bash
gcloud compute instances add-metadata NAME \
    --metadata-from-file startup-script=$HOME/dev/dotfiles/nix/google/startup-script.sh
```

A tool that creates the VM for you usually has a startup script setting of its own.
Give it the same file.

The metadata holds a copy of `startup-script.sh` only.
It reads `utils/bind-store.sh` from the data disk at boot, thus a change to the mount logic needs no new metadata.

## What else does not survive

The root disk keeps nothing between instances.
Set up these items again, or put them in the startup script:

- Packages that a system package manager installed
- The login shell, because `chsh` writes `/etc/passwd`
- Units in `/etc/systemd`, and files in `/etc` and `/usr/local`

Home manager covers everything else, because it writes to `$HOME` and the store.
