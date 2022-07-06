#!/bin/bash
function launch {
	# $1 indicates program to launch - must be name of executable in bash path
	# $2 indicates workspace to put on (0 indexed)
	# $3 indicates desired window state:
	#	- 1 -> vertically maxed
	#	- 2 -> vertically and horizontally maxed
	#	- 3 -> fullscreen
	$1 &
	sleep 5s
	WINID=$(wmctrl -l | grep -i $1 | cut -f1 -d " ")
	echo "win id = " $WINID
	echo "moving $1 to workspace $2"
	wmctrl -i -r $WINID -t $2
	sleep 1s
	# change window size based on arguments
	#	if 3, make full screen
	if [[ $3 -eq 3 ]]
       	then
		echo "changing $1 to fullscreen"
		wmctrl -i -r $WINID -b toggle,fullscreen
	else
		# if 2, make horizontally maxed
		if [[ $3 -eq 2 ]]
		then
			echo "changing $1 to maximized horz"
			wmctrl -i -r $WINID -b toggle,maximized_horz
		fi
		# if 1 or 2, make vertically maxed
		echo "changing $1 to maximized vert"
		wmctrl -i -r $WINID -b toggle,maximized_vert
	fi
}

launch firefox 8 2 &
launch spotify 9 1 &
launch slack 9 1 &
launch code 1 3 &
