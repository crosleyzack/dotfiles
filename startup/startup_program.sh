#!/bin/bash

# restart tmux session detatched
# This requires tmux exist on the host, however doing the `toolbox run -c devs tmux`
# alone results in ressurect not running. Ideally, will find a way to make this
# work without host requiring tmux
tmux new-session -d

FILE_PATH=$(realpath $BASH_SOURCE)
DIR=$(dirname $FILE_PATH)

# PATH="$PATH:/usr/local/bin:/bin:/usr/bin:$HOME/.nix-profile/bin/"

# "flatpak run app.zen_browser.zen"
# "flatpak run com.spotify.Client"
# "flatpak run org.signal.Signal"
# "flatpak run com.visualstudio.code"
# "ptyxis -s -x '"toolbox run -c devs tmux\""
declare -a progs=("snap run firefox" "spotify" "slack" "code" "bitwarden" "gnome-terminal -e 'tmux'")
printf '%s\n' "${progs[@]}"\

## now loop through the above array
for i in "${progs[@]}"
do
    echo "executing $i"
    exec $i > /dev/null &
done

echo "Programs launched, sleeping"
sleep 4
echo "Sleep done, repositioning windows via $DIR/position_windows.sh"

exec $DIR/position_windows.sh
