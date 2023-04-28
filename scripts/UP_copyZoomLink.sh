#!/bin/sh

# Gets the Zoom id from the current website and copies it to the clipboard.
# (You can also pass the Link as the first parameter.)
# Also opens Zoom, if it is not already open.

if [ "$1" ]; then
	TITLE="$1"
else
	TITLE=$(firefoxGetUrl.sh)
	if [ "$?" == 1 ]; then
		exit 1
	fi
fi

if ! (echo $TITLE | grep -q "zoom.us/j/"); then
	echo "No Zoom Link." 1>&2
	exit 2
fi

ID=$(echo $TITLE | sed 's/.*zoom.us\/j\/\(.*\)/\1/')
echo $ID

echo $ID | xclip -selection clipboard -r

# Start Zoom, if not already open
if ! pgrep ZoomLauncher >/dev/null; then
	ZoomLauncher &>/dev/null &
fi

