#!/bin/bash

function testfloat() {
	PROP=$(xprop -id $1)
	MIN=$(echo "$PROP" | grep "minimum size" | cut -d ":" -f 2)
	MAX=$(echo "$PROP" | grep "maximum size" | cut -d ":" -f 2)
	[ -n "$MIN" ] && [ -n "$MAX" ] && [ "$MIN" = "$MAX" ] && herbstclient set_attr clients."$1".floating true
}

herbstclient --idle rule | while read rule hook winid ; do
	if [ "$hook" = "newclient" ]; then
		testfloat "$winid"
	fi
done

