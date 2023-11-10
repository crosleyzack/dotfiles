#!/bin/bash

FILE_PATH=$(realpath $BASH_SOURCE)
DIR=$(dirname $FILE_PATH)

PATH="$PATH:/usr/local/bin:/bin:/usr/bin:$HOME/.nix-profile/bin/"

firefox > /dev/null &
spotify > /dev/null &
slack > /dev/null &
# signal_desktop > /dev/null &
# zoom > /dev/null &
code > /dev/null &
alacritty -e tmux > /dev/null &

echo "Programs launched, sleeping"
sleep 7
echo "Sleep done, repositioning windows via $DIR/position_windows.sh"

exec $DIR/position_windows.sh
