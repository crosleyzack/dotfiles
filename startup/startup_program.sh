#!/bin/bash

# To use, set as a program to run on OS start. This can be done on Ubuntu
#	in Applications > Statup Applications
# Note: This script should work on any X Window Manager system.

# Get desktop size. See https://askubuntu.com/questions/584688/how-can-i-get-the-monitor-resolution-using-the-command-line
X=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
Y=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)

function launch {
	# $1 indicates program to launch - must be name of executable in bash path
	# $2 indicates workspace to put on (0 indexed)
	# $3 indicates desired window state:
	#	- 1 -> vertically maxed
	#	- 2 -> vertically and horizontally maxed
	#	- 3 -> fullscreen
	# $4 indicates if multiple windows should be placed on successive desktops.
	# $5 if $3==1, horizontal space for window to use
	# $6 if $3==1, X placement of window 

	# Startup program and wait for launch.
	$1 &
	sleep 9s
	# Get process ids for running windows.
	WINIDS=$(wmctrl -l | grep -i $1 | cut -f1 -d " ")
	# For each process, move the program to the appropriate desktop.
	INDEX=0
	for WINID in $WINIDS
	do
		echo "win id = " $WINID
		# get workspace number to move to.
		WORKSPACE=$(($2+INDEX))
		echo "moving $1 to workspace $WORKSPACE"
		wmctrl -i -r $WINID -t $WORKSPACE
		# increment index if applicable.
		if [ "$4" = true ]
		then
			INDEX=$((INDEX+1))
		fi
		# Wait for successful move.
		sleep 1s
		# change window size based on arguments
		#	if 3, make full screen
		if [[ $3 -eq 3 ]]; then
			echo "changing $1 to fullscreen"
			wmctrl -i -r $WINID -b toggle,fullscreen
		elif [[ $3 -eq 2 ]]; then
			echo "changing $1 to maximized horz"
			wmctrl -i -r $WINID -e 0,0,0,$X,$Y
		elif [[ $3 -eq 1 ]]; then
			# if 1 make vertically maxed
			echo "changing $1 to maximized vert"
			wmctrl -i -r $WINID -e 0,$6,0,$5,$Y
		fi
		sleep 1s
	done
}

launch firefox 8 2 false &
THIRD=$(( $X / 3 ))
launch spotify 9 1 false $THIRD 0 &
launch slack 9 1 false $(( $X - $THIRD )) $THIRD &
launch code 1 3 true &
# Launch alacritty - cannot move via code above, as it doesn't show up in wmcrtl
alacritty -e tmux
