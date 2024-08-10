#!/bin/bash

# Avoid erros, which mess with output formatting
exec 2>/dev/null

# Cancel, if monitor is not initialized by bspwm
if ! bspc query -M -m $MONITOR &>/dev/null; then
	exit 1
fi

# Gets and displays the tags for the current monitor
source ~/.config/polybar/polybar_desktop_symbols.sh

function print_desktops() {
	# Get all desktops in order
	# DESKTOPS=( $(bspc query -D) )
	DESKTOPNAMES=( $(bspc query -D --names | sort) )
	DESKTOPS=( )
	for D in ${DESKTOPNAMES[@]}; do
		DESKTOPS=( ${DESKTOPS[@]} $(bspc query -D -d $D) )
	done

	# Get all occupied desktops
	OCCDESKTOPS=( $(bspc query -D -d .occupied) )
	# Get the focused desktop for the monitor
	SELDESKTOP=$(bspc query -D -m $MONITOR -d .active)

	for ((i = 0; i < ${#DESKTOPS[@]}; i++)); do
		D=${DESKTOPS[$i]}
		DNAME=${DESKTOPNAMES[$i]}
		# DNAME="$(bspc query -D -d $D --names)"

		SYMBOL=""

		# Test for fullscreen window
		if WID="$(bspc query -N -d $D -n .fullscreen)"; then
			true;
		# Get biggest window for Desktop
		# if [[ "$(bspc query -T -d $D | jq -r .layout)" = "tiled" ]]; then
		# Just search, since jq is a bit slow
		elif ( bspc query -T -d $D | grep -q ",\"layout\":\"tiled\"," ); then
			WID="$(bspc query -N "@$D:/" -n biggest.descendant_of)"
			# Workaround, in case something didn't work
			# [[ -z "$WID" ]] && WID="$(bspc query -N "@$D:/" -n any.descendant_of.window)"
		else
			# WID=$(bspc query -N "@$D:/" -n last.descendant_of)
			WID=$(bspc query -T -d "$D" | sed 's/.*"focusedNodeId":\([[:digit:]]*\).*/\1/')
		fi

		AFTERTEXT="%{T1} "
		if [[ "$WID" -ne 0 ]] && SYMBOL="$(getSymbol $WID)"; then
			AFTERTEXT="%{T6} %{T5}${DNAME}%{T6}%{O-1} %{T1}"
		elif [[ "$DNAME" =~ [1-9] ]]; then
			# Use default symbol, if no symbol has been assigned
			INDEX=$(( $DNAME - 1 ))
			if [[ "$D" = "$SELDESKTOP" ]]; then
				# Desktop is focused
				SYMBOL=${TAGUSE[$INDEX]}
			elif [[ "${OCCDESKTOPS[@]}" == *$D* ]]; then
				# Deskto is occupied
				SYMBOL=${TAGOCC[$INDEX]}
			else
				# Default
				SYMBOL=${TAGNORM[$INDEX]}
			fi
		else
			# Desktop is not a number. Print Name instead.
			# TODO: Use smaller font
			SYMBOL="$DNAME"
		fi

		if [[ "$D" = "$SELDESKTOP" ]]; then
			# TODO: Actions on click
			echo -n "%{R} %{T4}${SYMBOL}${AFTERTEXT}%{R}"
		else
			echo -n " %{T4}${SYMBOL}${AFTERTEXT}"
		fi
	done

	# Test for Monocle Layout
	# if [[ "$(bspc query -T -d $SELDESKTOP | jq -r .layout)" = "monocle" ]]; then
	if ( bspc query -T -d $SELDESKTOP | grep -q ",\"layout\":\"monocle\"," ); then
		COUNT=$(bspc query -N -d $SELDESKTOP -n .window.!hidden | wc -l)
		echo -n " 类 $COUNT"
	fi

	# TODO: Flags and other stuff

	echo "" # Print Newline. Shows Line on Polybar.
}

# Initial run
print_desktops

bspc subscribe node_add node_remove node_swap node_transfer node_focus node_state desktop_focus desktop_layout desktop_add desktop_rename desktop_remove | while read LINE; do print_desktops; done

