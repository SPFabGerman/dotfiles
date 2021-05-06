#!/bin/bash

# stty size

export USETRUECOLOR=1

if [[ "$1" =~ .*\.(png|jpg|pdf|mp4|mpv|mkv|webm|odt) ]]; then
	stpv "$@"
else
	~/scripts/previewer.sh "$1"
fi

