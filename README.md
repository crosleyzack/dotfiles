# Dotfiles

Configuration files for my linux system, for everything except Emacs.

To setup on new computer:

1. Pull repository.
2. Install programs & libraries from `debian`:
    1. Run `essential_programs.sh` first.
    2. Run `basic_libraries.sh` second.
    3. Run `tools.generic_installers.sh` third.
3. If on `gnome`, setup sudo-i3 environment:
    1. Run `workspace_keybindings.sh` from `gnome`.
4. Setup desired program settings:
    1. Run `tools/sym_links.sh` to use config files in dotfiles repo.
    2. Copy `git/.gitconfig` to `$HOME/.gitconfig` (Not done in a script, as name and email may require updating).
5. To setup default launch programs in Ubuntu:
    1. In `Startup Applications`, add `startup/startup_program.sh`
6. Install programming language libraries.
    1. Setup libraries in Python from `python/requirements.txt` via `python -m pip install -r ./python/requirements.txt`
7. If emacs is desired:
    1. Install emacs
    2. Pull emacs config from https://github.com/CrosleyZack/emacs_config.git

To keep everything updated, run `tools/update.sh`.

<img alt="gitleaks badge" src="https://img.shields.io/badge/protected%20by-gitleaks-blue">
