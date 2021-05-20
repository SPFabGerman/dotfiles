#!/bin/bash

# This script is a general purpose previewer.
# By default it does not show binary file text, but rather some general info about the file.
# If the file is a directory, the contents of the directory are shown.
# Last Argument is the file to be previewed. [TODO: Set it to "-" to read from stdin.]
# Use --line to specify a line to start with.
# All other options are parsed to highlight. (If it is called.)

# Set Default Terminal Size
if [[ -z "$HEIGHT" ]]; then
	HEIGHT=49 # Default Option
fi
if [[ -z "$WIDTH" ]]; then
	WIDTH=20
fi


# Run through every Argument and pass remaining arguments to the Programm directly.
ARGS=()
while [ "$#" -gt "1" ]; do
	# Start with specific Line Number
	if [ "$1" = "--line" ]; then
		ARGS=($ARGS --line-range=$2-$(($2+$HEIGHT)) -m $2)
		shift
	else
		ARGS=($ARGS $1)
	fi

	shift
done

# FILE is for the thing passed to the highlight programm,
# FILENAME holds the actuall filename.
FILE="$1"
FILENAME="$1"
shift



HIGHLIGHTTHEME=my_highlight
function plainTextHighlight() {
	highlight --syntax-by-name="$FILENAME" -O truecolor -s "$HIGHLIGHTTHEME" -D "$HOME/.config/highlight" --force --stdout "${ARGS[@]}" -- "$FILE"
	# Outputstyle for non-true-color
	# highlight --syntax-by-name="$FILENAME" -O xterm256 -s "$HIGHLIGHTTHEME" -D "$HOME/.config/highlight" --force --stdout "${ARGS[@]}" -- "$FILE"
}


if [ -d "$FILE" ]; then
	# For Directories
	exa -aFT -L1 --icons --group-directories-first --color=always "$FILENAME"
	exit 0
fi

MIMETYPE="$(mimetype -b -a "$FILENAME")"
case "$MIMETYPE" in
	*"gzip"*)
		# TODO: Archiver Implementation
		tar -tf "$FILE" | sed 's/^/- /';;
	*"zip"*)
		unzip -l "$FILE" | tail -n+4 | head -n-2 | awk '{print $4}' | sed 's/^/- /';;
	*"pdf"*)
		pdftotext "$FILE" -;;
	*"image/"*)
		chafa "$FILE";;
	*"json"*)
		FILE="-"
		jq . < "$FILENAME" | plainTextHighlight;;
	*"html"*)
		w3m -dump "$FILE";;
	# *"markdown"*)
	# 	mdcat "$FILE";;
	*"text"*)
		ARGS=(-l -j 2 $ARGS)
		plainTextHighlight "${ARGS[@]}";;
	*)
		# Other: Check for extension
		case "$FILENAME" in
			*"odt"|*"ods"|*"odp")
				odt2txt "$FILE";;
			*)
				# Fallback, if we have a binary file: print generall information
				file -b "$FILE" | sed -e 's/^/\* /' -e 's/, /\n\* /g';;
		esac
esac

# TODO: Diff Files

exit 0

