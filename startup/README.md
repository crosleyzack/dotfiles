# Startup

Contains scripts to be ran at startup for computer environment setup

NOTE: requires the GNOME "Window Calls" extension (`window-calls@domandoman.xyz`).

## startup_install.sh

Creates a `.desktop` file and sym links it from `$HOME/.config/autostart` so `startup_program.sh` runs on startup.

## startup_program.sh

Program which launches programs I use everyday.
It then waits for the windows to open and calls `position_windows.sh`, which holds every move and every layout.

## position_windows.sh

Program which moves windows to the appropriate virtual desktop and adjusts their size.
This will also layout N open windows of a given program on subsequent virtual desktops if desired.
This can be run to reposition windows once messed up.
The size and the place of a window need version 21 or later of the Window Calls extension.
The script moves the windows and skips the layout with an earlier version.
