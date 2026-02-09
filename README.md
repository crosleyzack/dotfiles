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

## Security

1. Use distribution with [SELinux or AppArmor](https://en.wikipedia.org/wiki/Security-Enhanced_Linux#Adoption)
2. Setup whole drive encryption on Linux install using LUKS (prompted during install)
3. Run `sudo visudo` to add line `Defaults timestamp_timeout=1`, limiting sudo sign in to one minute (defaults to five minutes)
4. Setup [gitsign](https://docs.sigstore.dev/cosign/signing/gitsign/) to sign git commits

## TODO

- set default mic and camera to usb webcam
- remove [pulse](./pulse)
- is [firefox](./firefox) still necessary?
- move [dygma](./dygma) to nix?
- remove [toolbox](./toolbox) in favor of nix-shell?
- Look into moving Lenovo to Silverblue + Nix
