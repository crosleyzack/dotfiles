# Dotfiles

Configuration files for my linux system, for everything except Emacs.

## New Computer Setup

To setup on new computer:

1. Pull repository.
2. Install packages
    - Install [nix](https://nixos.org/download/) using `nix/install_nix.sh`
    - Install packages with `nix-env -i -f nix/pkgs.nix`
3. If on `gnome`, setup sudo-i3 environment and desired settings:
    - Run `gnome/workspace_keybindings.sh` and `gnome/gnome_settings.sh`
4. Setup desired program settings:
    - Run `utils/sym_links.sh` to use config files in dotfiles repo.
5. To setup default launch programs in Ubuntu:
    - Run `startup/startup_install.sh`
6. If emacs is desired:
    - Install emacs
    - Pull emacs config from https://github.com/CrosleyZack/emacs_config.git

To keep everything updated, run `utils/update.sh`.

## Security

1. Use distribution with [SELinux](https://en.wikipedia.org/wiki/Security-Enhanced_Linux#Adoption)
2. Setup whole drive encryption on Linux install using LUKS (prompted during install)
3. Run `sudo visudo` to add line `Defaults timestamp_timeout=1`, limiting sudo sign in to one minute (defaults to five minutes)
4. Setup [gitsign](https://docs.sigstore.dev/cosign/signing/gitsign/) to sign git commits

## TODO

- cleanup

<img alt="gitleaks badge" src="https://img.shields.io/badge/protected%20by-gitleaks-blue">
