#!/bin/sh

if [ "$2" = "zoom" ] && [ "$3" = "zoom" ]; then
	NAME="$(xprop -id $1 _NET_WM_NAME | sed "s/.* = \"\(.*\)\"/\1/")"
	if [ "$NAME" = "zoom" ]; then
		sleep 1
		NAME="$(xprop -id $1 _NET_WM_NAME | sed "s/.* = \"\(.*\)\"/\1/")"
		if [ "$NAME" = "zoom" ]; then
			echo "state=floating"
			exit
		fi
	fi
fi

if [ "$2" = "Emacs" ] && [ "$3" = "emacs" ]; then
	NAME="$(xprop -id $1 _NET_WM_NAME | sed "s/.* = \"\(.*\)\"/\1/")"
	if [ "$NAME" = "Question" ]; then
		echo "state=floating"
		exit
	fi
fi

