#!/bin/bash

# restart tmux session detatched
# This requires tmux exist on the host, however doing the `toolbox run -c devs tmux`
# alone results in ressurect not running. Ideally, will find a way to make this
# work without host requiring tmux
tmux new-session -d

FILE_PATH=$(realpath $BASH_SOURCE)
DIR=$(dirname $FILE_PATH)

PATH="$PATH:/usr/local/bin:/bin:/usr/bin:$HOME/.nix-profile/bin/"

flatpak run app.zen_browser.zen > /dev/null &
flatpak run com.spotify.Client > /dev/null &
flatpak run org.signal.Signal > /dev/null &
flatpak run com.visualstudio.code > /dev/null &

# run terminal in toolbox
# alacritty -e toolbox run -c devs tmux
ptyxis -s -x "toolbox run -c devs tmux"

echo "Programs launched, sleeping"
Sleep 7
echo "Sleep done, repositioning windows via $DIR/position_windows.sh"

exec $DIR/position_windows.sh
