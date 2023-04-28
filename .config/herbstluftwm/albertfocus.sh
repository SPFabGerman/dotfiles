#!/bin/bash

function movemouse() {
	window_id="$1"
	upper_left_x=$(xwininfo -id $window_id | grep -i 'absolute upper-left x' | cut --delimiter=' ' --fields=7)
	upper_left_y=$(xwininfo -id $window_id | grep -i 'absolute upper-left y' | cut --delimiter=' ' --fields=7)

	if [ $upper_left_x -ne "-1" -o $upper_left_y -ne "-1" ] ; then
		eval $(xdotool getwindowgeometry --shell $window_id)

		new_upper_left_x=$(( $WIDTH / 2 ))
		new_upper_left_y=$(( $HEIGHT / 2 ))

		xdotool mousemove --window $window_id $new_upper_left_x $new_upper_left_y
	fi
}

herbstclient --idle rule | while read rule hook winid ; do
	if [ "$hook" = "albertfocus" ]; then
		movemouse "$winid"
	fi
done

