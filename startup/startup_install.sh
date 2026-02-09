#!/bin/bash

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
