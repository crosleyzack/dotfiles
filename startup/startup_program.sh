#!/bin/bash

################################################################################
# Startup Program Launcher
#
# Purpose:
#   Automatically launches a predefined set of applications on system startup
#   and positions them on specific workspaces using the position_windows.sh
#   script.
#
# Behavior:
#   1. Starts a detached tmux session in the background
#   2. Determines which system profile to use based on NIX_SYSTEM_ID:
#      - "framework": Launches work setup (Nix VSCode, Snap apps, gnome-terminal)
#      - Default: Launches personal setup (Flatpak apps, ptyxis terminal)
#   3. Launches all applications in the selected profile:
#      - Each program is executed in the background
#      - Output is redirected to /dev/null
#      - 0.1 second delay between launches
#   4. Waits 9 seconds for applications to fully start
#   5. Executes position_windows.sh to arrange windows on workspaces
#
# System Profiles:
#
#   Framework (work):
#   - VSCode (from Nix)
#   - Firefox (Snap)
#   - Slack (Snap)
#   - Proton Pass (Snap)
#   - Obsidian (Snap)
#   - GNOME Terminal
#
#   Default (personal):
#   - Firefox
#   - VSCode
#   - Obsidian (Flatpak)
#   - Proton Mail (Flatpak)
#   - Proton Pass (Flatpak)
#   - Signal (Flatpak)
#   - Ptyxis terminal with tmux
#
# Environment Variables:
#   NIX_SYSTEM_ID - System identifier (default: "framework")
#                   Set by Nix home-manager configuration
#
# Prerequisites:
#   - tmux installed on host system
#   - position_windows.sh in the same directory
#   - Applications specified in the profile must be installed
#
# Note:
#   This script is designed to be called by startup_install.sh or configured
#   as a startup application in your desktop environment.
################################################################################

# restart tmux session detatched
# This requires tmux exist on the host, however doing the `toolbox run -c devs tmux`
# alone results in ressurect not running. Ideally, will find a way to make this
# work without host requiring tmux
tmux new-session -d

FILE_PATH=$(realpath $BASH_SOURCE)
DIR=$(dirname $FILE_PATH)

# NIX_SYSTEM_ID set by nix home manager for each computer
NIX_SYSTEM_ID="${NIX_SYSTEM_ID:-framework}"
echo "NIX_SYSTEM_ID=$NIX_SYSTEM_ID"
case $NIX_SYSTEM_ID in
    framework)
        # work
        declare -a progs=("/home/zackary-crosley/.nix-profile/bin/code" "snap run firefox" "snap run slack" "snap run proton-pass" "snap run obsidian" "gnome-terminal")
    ;;
    *)
        # default
        declare -a progs=("firefox" "code" "flatpak run md.obsidian.Obsidian" "flatpak run me.proton.Mail" "flatpak run me.proton.Pass" "flatpak run org.signal.Signal" "ptyxis -e /usr/bin/zsh -c tmux")
    ;;
esac
printf '%s\n' "${progs[@]}"\

## now loop through the above array
for i in "${progs[@]}"
do
    echo "executing $i"
    exec $i > /dev/null &
    sleep .1s
done

echo "Programs launched, sleeping"
sleep 9
echo "Sleep done, repositioning windows via $DIR/position_windows.sh"

exec $DIR/position_windows.sh
