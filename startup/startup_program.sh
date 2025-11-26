#!/bin/bash

# restart tmux session detatched
# This requires tmux exist on the host, however doing the `toolbox run -c devs tmux`
# alone results in ressurect not running. Ideally, will find a way to make this
# work without host requiring tmux
tmux new-session -d

FILE_PATH=$(realpath $BASH_SOURCE)
DIR=$(dirname $FILE_PATH)

# PATH="$PATH:/usr/local/bin:/bin:/usr/bin:$HOME/.nix-profile/bin/"

# work
# declare -a progs=("code --disable-gpu" "snap run firefox" "snap run spotify" "snap run slack" "snap run proton-pass" "snap run obsidian" "gnome-terminal -- tmux")
# personal
declare -a progs=("firefox" "code" "flatpak run md.obsidian.Obsidian" "flatpak run me.proton.Mail" "flatpak run me.proton.Pass" "flatpak run org.signal.Signal" "ptyxis -e /usr/bin/zsh -c tmux")
printf '%s\n' "${progs[@]}"\

## now loop through the above array
for i in "${progs[@]}"
do
    echo "executing $i"
    exec $i > /dev/null &
    sleep .1s
done

echo "Programs launched, sleeping"
sleep 5
echo "Sleep done, repositioning windows via $DIR/position_windows.sh"

exec $DIR/position_windows.sh
