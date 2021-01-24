#!/bin/bash

# This script is a general purpose previewer.
# By default it does not show binary file text, but rather some general info about the file.
# If the file is a directory, the contents of the directory are shown.
# Last Argument is the file to be previewed. [TODO: Set it to "-" to read from stdin.]
# Use --line to specify a line to start with.
# All other options are parsed to highlight. (If it is called.)

# Run through every Argument and pass remaining arguments to the Programm directly.
ARGS=()
while [ "$#" -gt "1" ]; do
	# Start with specific Line Number
	if [ "$1" = "--line" ]; then
		# Get Terminal Size
		if [[ -z "$HEIGHT" ]]; then
			HEIGHT=49 # Default Option
		fi
		ARGS=($ARGS --line-range=$2-$(($2+$HEIGHT)) -m $2)
		shift
	else
		ARGS=($ARGS $1)
	fi

	shift
done

# TODO: Make this an option
if [[ "$USETRUECOLOR" = 1 ]]; then
	OUTPUTSTYLE=truecolor
	HIGHLIGHTTHEME=my_highlight
else
	OUTPUTSTYLE=xterm256
	# HIGHLIGHTTHEME=base16/my_highlight_16
	HIGHLIGHTTHEME=my_highlight
fi

FILE="$1"
shift

function plainTextHighlight() {
	highlight "$FILE" -O "$OUTPUTSTYLE" -s "$HIGHLIGHTTHEME" -l -j 2 -D "$HOME/.config/highlight" --force --stdout "${ARGS[@]}"
}

if [ -d "$FILE" ]; then
	# For Directories
	exa -aFT -L1 --icons --group-directories-first --color=always "$FILE"
else
	MIMETYPE="$(mimetype -b -a "$FILE")"
	case "$MIMETYPE" in
		*"gzip"*)
			tar -tf "$FILE" | sed 's/^/- /';;
		*"zip"*)
			unzip -l "$FILE" | tail -n+4 | head -n-2 | awk '{print $4}' | sed 's/^/- /';;
		*"pdf"*)
			pdftotext "$FILE" -;;
		*"image"*)
			chafa "$FILE";;
		*"text"*)
			plainTextHighlight "${ARGS[@]}";;
		*)
			# Fallback, if we have a binary file
			file -b "$FILE" | sed -e 's/^/\* /' -e 's/, /\n\* /g';;
	esac
fi

exit 0

