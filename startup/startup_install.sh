#!/bin/bash

FILE_PATH=$(realpath $BASH_SOURCE)
# echo "FILE_PATH = $FILE_PATH"
DIR_PATH=$(dirname $FILE_PATH)
# echo "DIR_PATH = $DIR_PATH"

if which rpm-ostree > /dev/null; then
  rpm-ostree install xrandr wmctrl
fi

# Create startup.desktop
DESKTOP_FILE="startup.desktop"
rm -f $DESKTOP_FILE
echo "[Desktop Entry]
Type=Application
Name=StartupScript
Exec=$DIR_PATH/startup_program.sh
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

### OLD attempt crontab
# COMMAND="$DIR_PATH/startup_program.sh"
# echo "Adding command $COMMAND to startup"
#write out current crontab
# crontab -l > mycron
#echo new cron into cron file
# echo "@reboot $COMMAND" >> mycron
#install new cron file
# crontab mycron
# rm mycron
