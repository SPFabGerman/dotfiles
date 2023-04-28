#!/bin/bash

GAPSIZE=8

function movemouse() {
	window_id=$(xdotool getactivewindow)
	upper_left_x=$(xwininfo -id $window_id | grep -i 'absolute upper-left x' | cut --delimiter=' ' --fields=7)
	upper_left_y=$(xwininfo -id $window_id | grep -i 'absolute upper-left y' | cut --delimiter=' ' --fields=7)

	if [ $upper_left_x -ne "-1" -o $upper_left_y -ne "-1" ] ; then
		eval $(xdotool getwindowgeometry --shell $window_id)

		eval M"$(xdotool getmouselocation --shell | grep "^X=")"
		eval M"$(xdotool getmouselocation --shell | grep "^Y=")"

		new_upper_left_x=$(( $WIDTH / 2 ))
		new_upper_left_y=$(( $HEIGHT / 2 ))

		if ! [[ ${X}-${GAPSIZE} -le $MX && ${Y}-${GAPSIZE} -le $MY && $X+${WIDTH}+${GAPSIZE} -ge $MX && $Y+${HEIGHT}+${GAPSIZE} -ge $MY ]]; then
			xdotool mousemove --window $window_id $new_upper_left_x $new_upper_left_y
		fi
	fi
}

herbstclient watch tags.focus.tiling.focused_frame.selection
herbstclient --idle '(attribute_changed)' | while read hook attr title ; do
	case $hook in
		focus_changed)
			movemouse
			;;
		attribute_changed)
			if [[ "$attr" = "tags.focus.tiling.focused_frame.selection" ]]; then
				movemouse
			fi
			;;
	esac
done

