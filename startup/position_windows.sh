#!/bin/bash

################################################################################
# Automatic Window Positioning Script
#
# Purpose:
#   Automatically positions and sizes application windows on specific virtual
#   desktops/workspaces upon system startup or when manually executed.
#
# Behavior:
#   1. Reads the logical screen size from Mutter.
#   2. Defines move_to_workspace(), which finds all windows of a given window
#      class and moves each one to a specified workspace.
#   3. Defines position_on_workspace(), which gives each of those windows a
#      layout:
#        * FULLSCREEN (3): Full screen mode
#        * VERT_HORZ_MAXED (2): Maximized both vertically and horizontally
#        * VERT_MAXED (1): Vertically maximized with custom width and position
#      This function does nothing when the extension is too old. See the note.
#   4. Defines position(), which calls both of the functions above.
#   5. Executes positioning commands for predefined applications:
#      - Firefox (workspace 8, maximized)
#      - VS Code (workspace 1, fullscreen, multiple windows on successive desktops)
#      - Zed (workspace 1, fullscreen, multiple windows on successive desktops)
#      - Proton Mail (workspace 5, maximized)
#      - Obsidian (workspace 6, maximized)
#      - Proton Pass (workspace 7, maximized)
#      - Signal (workspace 9, half width)
#      - Spotify (workspace 9, half width, left side)
#      - Slack (workspace 9, half width, right side)
#
# Mechanism:
#   GNOME permits no window control from an external program on Wayland. The
#   "Window Calls" extension adds a D-Bus interface for that control. This
#   script sends every move and every resize through that interface.
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - GNOME Shell with the "Window Calls" extension enabled
#     (window-calls@domandoman.xyz). The layout step needs version 21 or later.
#   - gdbus (package libglib2.0-bin)
#
# Usage:
#   Run manually or configure as a startup application in your desktop
#   environment (e.g., GNOME Startup Applications, KDE Autostart)
#
# Note:
#   The layout step waits on a newer build of the extension in nixpkgs.
#     Attribute:  gnomeExtensions.window-calls
#     UUID:       window-calls@domandoman.xyz
#     Upstream:   https://extensions.gnome.org/extension/4724/window-calls/
#     In nixpkgs unstable on 2026-09-23:  version 20
#     Needed by the layout step:          version 21
#
#   Version 21 declares support for GNOME Shell 45 to 50. Version 20 declares
#   no support for GNOME Shell 50. GNOME does not load an extension that
#   declares no support for the version of the shell. This host runs GNOME
#   Shell 50.
#
#   Read the version of nixpkgs with this command:
#     nix eval --raw nixpkgs#gnomeExtensions.window-calls.version
#
#   This script moves the windows with every version of the extension that
#   GNOME loads. It lays the windows out with version 21 or later only, and it
#   prints a message for each application that it leaves in place.
################################################################################

# D-Bus address of the Window Calls extension.
WC_DEST="org.gnome.Shell"
WC_PATH="/org/gnome/Shell/Extensions/Windows"
WC_IFACE="org.gnome.Shell.Extensions.Windows"
WC_UUID="window-calls@domandoman.xyz"

# The first version of the extension that GNOME Shell 50 loads.
WC_LAYOUT_MIN_VERSION=21

# Sends one action to the extension. $1 is the method, and the rest are the
# arguments of that method.
function wc_call {
    local method="$1"
    shift
    gdbus call --session --dest "$WC_DEST" --object-path "$WC_PATH" \
        --method "$WC_IFACE.$method" "$@" > /dev/null
}

# Prints the id of every window of a class, one for each line.
# $1 is a fragment of the class, of no sensitivity to case.
#
# "List" answers one line of JSON. Each window of that line holds no "},{",
# thus that pair separates the records.
#
# The order of the extension follows the stack of the windows, which changes
# with every start. The sort by title keeps one project on one workspace.
function wc_window_ids {
    local fragment="$1" raw records rec class id title
    raw=$(gdbus call --session --dest "$WC_DEST" --object-path "$WC_PATH" \
        --method "$WC_IFACE.List") || return 1
    records=${raw//\},\{/$'\n'}
    shopt -s nocasematch
    while IFS= read -r rec; do
        [[ $rec =~ \"wm_class\":\"([^\"]*)\" ]] || continue
        class=${BASH_REMATCH[1]}
        [[ $class == *"$fragment"* ]] || continue
        [[ $rec =~ \"id\":([0-9]+) ]] || continue
        id=${BASH_REMATCH[1]}
        if [[ $rec =~ \"title\":\"([^\"]*)\" ]]; then
            title=${BASH_REMATCH[1]}
        else
            title=
        fi
        printf '%s\t%s\n' "$title" "$id"
    done <<< "$records" | sort | cut -f2
    shopt -u nocasematch
}

# Prints the version of the Window Calls extension, or 0 when GNOME holds no
# such extension.
#
# GetExtensionInfo answers a dictionary. The version of that dictionary is a
# number, such as <21.0>, thus this function keeps the whole part only. A type
# name, such as "uint32", comes before the number of some values. The
# dictionary holds "version-name" as well, and the quote before the colon of
# the pattern keeps that other key out of the match.
function wc_extension_version {
    local info
    info=$(gdbus call --session --dest org.gnome.Shell \
        --object-path /org/gnome/Shell \
        --method org.gnome.Shell.Extensions.GetExtensionInfo "$WC_UUID") \
        || { echo 0; return; }
    if [[ $info =~ \'version\':\ \<([a-z]+[0-9]*\ )?\'?([0-9]+) ]]; then
        echo "${BASH_REMATCH[2]}"
    else
        echo 0
    fi
}

# Prints the width and the height of the primary monitor, in logical pixels.
#
# Mutter places a window in logical pixels, which hold the scale of the
# monitor. xrandr reports the pixels of XWayland, which are of another size.
#
# The scale is a fraction, and the shell divides integers only. The scale
# becomes thousandths, which keeps the result correct to one pixel.
function logical_screen_size {
    local state logical mode scale whole part milli width height
    state=$(gdbus call --session --dest org.gnome.Mutter.DisplayConfig \
        --object-path /org/gnome/Mutter/DisplayConfig \
        --method org.gnome.Mutter.DisplayConfig.GetCurrentState) || return 1

    # Field five of a logical monitor holds "true" for the primary one.
    logical=$(grep -oE '\([0-9]+, [0-9]+, [0-9.]+, uint32 [0-9]+, true,' \
        <<< "$state" | head -1)
    [[ $logical =~ ^\([0-9]+,\ [0-9]+,\ ([0-9.]+), ]] || return 1
    scale=${BASH_REMATCH[1]}

    mode=$(grep -oE "\('[^']+', [0-9]+, [0-9]+,[^{]*\{[^}]*'is-current': <true>" \
        <<< "$state" | head -1)
    [[ $mode =~ ^\(\'[^\']+\',\ ([0-9]+),\ ([0-9]+), ]] || return 1
    width=${BASH_REMATCH[1]}
    height=${BASH_REMATCH[2]}

    whole=${scale%%.*}
    part=${scale#*.}000
    milli=$((whole * 1000 + 10#${part:0:3}))

    echo "$((width * 1000 / milli)) $((height * 1000 / milli))"
}

# The extension answers no call when GNOME holds it disabled. Every later call
# would fail without a message, thus this check stops the script here.
if ! wc_call List 2> /dev/null; then
    echo "position_windows.sh: the Window Calls extension answers no D-Bus call"
    logger "position_windows.sh: the Window Calls extension answers no D-Bus call"
    exit 1
fi

# One read of the version serves every call of position_on_workspace.
WC_VERSION=$(wc_extension_version)
echo "position_windows.sh: Window Calls version $WC_VERSION"
logger "position_windows.sh: Window Calls version $WC_VERSION"

read -r X Y < <(logical_screen_size)

if [[ -z "$Y" || -z "$X" ]]; then
    echo "position_windows.sh: invalid screen size $X x $Y"
    logger "position_windows.sh: invalid screen size $X x $Y"
    exit 1
fi
echo "position_windows.sh: screen size $X x $Y"
logger "position_windows.sh: screen size $X x $Y"

# enum options for layout
VERT_MAXED=1
VERT_HORZ_MAXED=2
FULLSCREEN=3

# Moves every window of a class to a workspace.
# $1 indicates the window class to move - a fragment is enough
# $2 indicates workspace to put on (0 indexed)
# $3 indicates if multiple windows should be placed on successive desktops.
function move_to_workspace {
    local winids winid index=0 workspace
    winids=$(wc_window_ids "$1")
    if [ -z "$winids" ]; then
        echo "WARN: no Windows found for class $1"
        return 0
    fi
    for winid in $winids
    do
	workspace=$(($2+index))
	echo "position_windows.sh: moving $1 ($winid) to workspace $workspace"
	logger "position_windows.sh: moving $1 ($winid) to workspace $workspace"
	wc_call MoveToWorkspace "$winid" "$workspace"
	if [ "$3" = true ]
	then
	    index=$((index+1))
	fi
	# Wait for successful move.
	sleep 1s
    done
}

# Gives every window of a class a size and a place on the workspace that holds
# it.
# $1 indicates the window class to position - a fragment is enough
# $2 indicates desired window state:
#	- 1 -> vertically maxed
#	- 2 -> vertically and horizontally maxed
#	- 3 -> fullscreen
# $3 if $2==1, horizontal space for window to use
# $4 if $2==1, X placement of window
#
# GNOME Shell 50 loads version 21 of the extension and no earlier one. An
# earlier version answers the move calls of a shell that loads it, but this
# host keeps every layout call in reserve for version 21.
function position_on_workspace {
    local winids winid
    if (( WC_VERSION < WC_LAYOUT_MIN_VERSION )); then
	echo "position_windows.sh: no layout of $1, Window Calls version $WC_VERSION is less than $WC_LAYOUT_MIN_VERSION"
	logger "position_windows.sh: no layout of $1, Window Calls version $WC_VERSION is less than $WC_LAYOUT_MIN_VERSION"
	return 0
    fi
    winids=$(wc_window_ids "$1")
    if [ -z "$winids" ]; then
        echo "WARN: no Windows found for class $1"
        return 0
    fi
    for winid in $winids
    do
	# change window size based on arguments
	#   if 3, make full screen
	if [[ $2 -eq $FULLSCREEN ]]; then
            echo "position_windows.sh: changing $1 to fullscreen"
            logger "position_windows.sh: changing $1 to fullscreen"
	    wc_call MakeFullscreen "$winid"
	elif [[ $2 -eq $VERT_HORZ_MAXED ]]; then
            echo "position_windows.sh: changing $1 to maximized"
            logger "position_windows.sh: changing $1 to maximized"
	    wc_call Maximize "$winid"
	elif [[ $2 -eq $VERT_MAXED ]]; then
	    # if 1 make vertically maxed
            echo "position_windows.sh: changing $1 to maximized vert ($4,0,$3,$Y)"
            logger "position_windows.sh: changing $1 to maximized vert ($4,0,$3,$Y)"
	    wc_call MoveResize "$winid" "$4" 0 "$3" "$Y"
	fi
	sleep .5s
    done
}

# Moves every window of a class, then lays each one out. The arguments follow
# the two functions above.
# $1 window class, $2 workspace, $3 window state, $4 successive desktops,
# $5 width, $6 X placement
function position {
    move_to_workspace "$1" "$2" "$4"
    position_on_workspace "$1" "$3" "$5" "$6"
}

# TODO:
#  Get list of display names
#  If more than one, set largest as primary
#  move each window to primary display
# NOTE: looks like location might require calculation
#  see https://github.com/jc00ke/move-to-next-monitor/blob/master/move-to-next-monitor

THIRD=$(($X / 3))
HALF=$(($X / 2))
#        program desktop_id
#                  window_size      array_windows
#                                         xSize ySize
position firefox      8 $VERT_HORZ_MAXED false $X    $Y &
position code         1 $FULLSCREEN      true  $X    $Y &
position dev.zed.Zed  1 $FULLSCREEN      true  $X    $Y &
# personal
position mail.Proton  5 $VERT_HORZ_MAXED false $X    $Y &
position obsidian     6 $VERT_HORZ_MAXED false $X    $Y &
position pass.Proton  7 $VERT_HORZ_MAXED false $X    $Y &
position signal       9 $VERT_HORZ_MAXED false $HALF 0 &
# work
position spotify      9 $VERT_MAXED      false $HALF 0 &
position slack        9 $VERT_MAXED      false $HALF $HALF &
