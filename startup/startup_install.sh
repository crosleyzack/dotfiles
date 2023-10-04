#!/bin/bash

FILE_PATH=$(realpath $BASH_SOURCE)
# echo "FILE_PATH = $FILE_PATH"
DIR_PATH=$(dirname $FILE_PATH)
# echo "DIR_PATH = $DIR_PATH"

# Create startup.desktop
DESKTOP_FILE="$DIR_PATH/startup.desktop"
rm -f $DESKTOP_FILE
echo "[Desktop Entry]
Type=Application
Name=StartupScript
Exec=$DIR_PATH/startup_program.sh
OnlyShowIn=GNOME;" >> $DESKTOP_FILE

# link to generated startup script.
mkdir -p $HOME/.config/autostart
rm -f $HOME/.config/autostart/startup.desktop
ln -s $DESKTOP_FILE $HOME/.config/autostart/startup.desktop
# cp "$DIR_PATH/startup.desktop" $HOME/.config/autostart

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
