<img alt="gitleaks badge" src="https://img.shields.io/badge/protected%20by-gitleaks-blue">

# Dotfiles

Configuration files for my linux system

## New Computer Setup

To setup on new computer:

1. Pull repository.
2. Install packages
    - Install [nix](https://nixos.org/download/) using [nix/install.sh](nix/install.sh)
    - See [nix/README.md](nix/README.md) for more details
3. To setup default launch programs:
    - Run [startup/startup_install.sh](startup/startup_install.sh)
4. Pull and setup [daily wallpaper](https://github.com/CrosleyZack/random_desktop_quote)

To keep everything updated, run [utils/update.sh](utils/update.sh)

## TODO

- is [firefox](./firefox) still necessary?
- remove [dygma/setup.sh](./dygma/setup.sh) as redundant
- remove [toolbox](./toolbox) in favor of nix-shell?
- Look into moving Lenovo to Silverblue + Nix
