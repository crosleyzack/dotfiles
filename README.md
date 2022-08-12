# Dotfiles

Configuration files for my linux system, for everything except Emacs.

To setup on new computer:

1. Pull repository.
2. Install programs & libraries from `gnome`:
    1. Run `essential_programs.sh` first.
    2. Run `basic_libraries.sh` second.
    3. Run `workspace_keybindings.sh` third.
3. Setup desired program settings:
    1. Run `sym_links.sh` to use config files in dotfiles repo.
    2. Copy `git/.gitconfig` to `$HOME/.gitconfig` (Not done in a script, as name and email may require updating).
4. To setup default launch programs:
    1. In `Startup Applications`, add `startup/startup_program.sh`
5. If emacs is desired:
    1. Install emacs
    2. Pull emacs config from https://github.com/CrosleyZack/emacs_config.git

<img alt="gitleaks badge" src="https://img.shields.io/badge/protected%20by-gitleaks-blue">
