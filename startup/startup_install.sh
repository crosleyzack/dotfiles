#!/bin/bash

################################################################################
# Startup Script Installation and Configuration
#
# Purpose:
#   Configures startup_program.sh to run automatically on user login by
#   creating and installing a desktop entry file.
#
# Behavior:
#   1. Verifies required tools are installed (wmctrl, xrandr)
#   2. Creates a .desktop file that executes startup_program.sh
#   3. Passes NIX_SYSTEM_ID environment variable if it's set
#   4. Creates the desktop entry file in the script's directory
#   5. Symlinks the desktop file to two locations:
#      - ~/.config/autostart/ (for automatic startup on login)
#      - ~/.local/share/applications/ (for manual launching from app menu)
#
# Desktop Entry Configuration:
#   - Type: Application
#   - Name: StartupScript
#   - Terminal: false (runs without opening a terminal)
#   - OnlyShowIn: GNOME (only appears in GNOME desktop environment)
#
# Environment Variables:
#   NIX_SYSTEM_ID - Optional system identifier passed to startup_program.sh
#                   to determine which application profile to launch
#
# Prerequisites:
#   - wmctrl installed (for window positioning)
#   - xrandr installed (for screen resolution detection)
#   - GNOME desktop environment (or compatible)
#   - startup_program.sh in the same directory
#
# Usage:
#   Run this script once to install the startup configuration.
#   After running, startup_program.sh will execute automatically on each login.
################################################################################

FILE_PATH=$(realpath $BASH_SOURCE)
# echo "FILE_PATH = $FILE_PATH"
DIR_PATH=$(dirname $FILE_PATH)
# echo "DIR_PATH = $DIR_PATH"

if [ ! -f "$(command -v wmctrl)" ]; then
    echo "wmctrl must be installed for startup program to work"
    exit 1
fi

if [ ! -f "$(command -v xrandr)" ]; then
    echo "xrandr must be installed for startup program to work"
    exit 1
fi

COMMAND="$DIR_PATH/startup_program.sh"
if [[ -n "$NIX_SYSTEM_ID" ]]; then
    # if we have a nix system id, add that to our command
    COMMAND="env NIX_SYSTEM_ID=$NIX_SYSTEM_ID $COMMAND"
fi

# Create startup.desktop
DESKTOP_FILE="startup.desktop"
rm -f $DESKTOP_FILE
echo "[Desktop Entry]
Type=Application
Name=StartupScript
Terminal=false
Path=$DIR_PATH
Exec=$COMMAND
OnlyShowIn=GNOME;" > "$DIR_PATH/$DESKTOP_FILE"

# link to generated startup script.
AUTOSTART_DIR="$HOME/.config/autostart"
APP_DIR="$HOME/.local/share/applications"
mkdir -p $AUTOSTART_DIR
rm -f $AUTOSTART_DIR/startup.desktop
ln -s "$DIR_PATH/$DESKTOP_FILE" $AUTOSTART_DIR/startup.desktop
mkdir -p $APP_DIR
rm -f $APP_DIR/startup.desktop
ln -s "$DIR_PATH/$DESKTOP_FILE" $APP_DIR/startup.desktop

echo "Startup configured!"
