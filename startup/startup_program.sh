#!/bin/bash

# restart tmux session detatched
# This requires tmux exist on the host, however doing the `toolbox run -c devs tmux`
# alone results in ressurect not running. Ideally, will find a way to make this
# work without host requiring tmux
tmux new-session -d

FILE_PATH=$(realpath $BASH_SOURCE)
DIR=$(dirname $FILE_PATH)

PATH="$PATH:/usr/local/bin:/bin:/usr/bin:$HOME/.nix-profile/bin/"

firefox > /dev/null &
flatpak run com.spotify.Client > /dev/null &
flatpak run com.slack.Slack > /dev/null &
# signal_desktop > /dev/null &
# zoom > /dev/null &
code > /dev/null &
# start our term
alacritty -e toolbox run -c devs tmux > /dev/null

echo "Programs launched, sleeping"
sleep 7
echo "Sleep done, repositioning windows via $DIR/position_windows.sh"

exec $DIR/position_windows.sh
