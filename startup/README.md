# Startup

Contains scripts to be ran at startup for computer environment setup

NOTE: requires wmctrl

## startup_install.sh

Creates a `.desktop` file and sym links it from `$HOME/.config/autostart` so `startup_program.sh` runs on startup.

## startup_program.sh

Program which launches programs I use everyday. Then calls out to `position_windows.sh` to move the windows to the appropriate locations.

## position_windows.sh

Program which moves windows to the appropriate virtual desktop and adjusts their size. This will also layout N open windows of a given program on subsequent virtual desktops if desired. This can be run to reposition windows once messed up.
