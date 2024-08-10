#!/bin/bash

# Avoid erros, which mess with output formatting
# exec 2>/dev/null

function hc() {
	herbstclient "$@"
}

# Gets and displays the tags for the current monitor
source ~/.config/polybar/polybar_desktop_symbols.sh

function print_desktops() {
	# Get all Tags in order
    TAGS=( $(hc foreach T tags.by-name. echo T | sed 's/^tags\.by-name\.\(\d*\)\(\..*\)\?/\1/' | sort) )

	SELTAG="$(hc get_attr monitors.focus.tag)"

	for T in "${TAGS[@]}"; do
		SYMBOL=""

		WID="$(hc list_clients --tag="$T" | head -n 1)"

		AFTERTEXT="%{T1} "
		if [[ -n "$WID" ]] && SYMBOL="$(getSymbol $WID)"; then
			AFTERTEXT="%{T6} %{T5}${T}%{T6}%{O-1} %{T1}"
		elif [[ "$T" =~ ^[1-9]$ ]]; then
			# Use default symbol, if no symbol has been assigned
			INDEX=$(( $T - 1 ))
			if [[ "$T" = "$SELTAG" ]]; then
				# Tag is focused
				SYMBOL=${TAGUSE[$INDEX]}
			elif [[ -n "$WID" ]]; then
				# Tag is occupied
				SYMBOL=${TAGOCC[$INDEX]}
			else
				# Default
				SYMBOL=${TAGNORM[$INDEX]}
			fi
		else
			# Desktop is not a number. Print Name instead.
			# TODO: Use smaller font
			SYMBOL="$T"
		fi

		if [[ "$T" = "$SELTAG" ]]; then
			# TODO: Actions on click
			echo -n "%{R} %{T4}${SYMBOL}${AFTERTEXT}%{R}"
		else
			echo -n " %{T4}${SYMBOL}${AFTERTEXT}"
		fi
	done

	# Test for Monocle Layout
	# if ( bspc query -T -d $SELDESKTOP | grep -q ",\"layout\":\"monocle\"," ); then
	# 	COUNT=$(bspc query -N -d $SELDESKTOP -n .window.!hidden | wc -l)
	# 	echo -n " 类 $COUNT"
	# fi

	echo "" # Print Newline. Shows Line on Polybar.
}

# Initial run
print_desktops

hc --idle '(tag_.*|focus_changed)' | while read LINE; do print_desktops; done

