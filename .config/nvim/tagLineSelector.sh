#!/bin/bash

# This is a script, that will prompt the user to select a tag in a file and then writes the line number of the tag in a another File.
# $1 is the code file

# Set Terminal Size
export HEIGHT="$(stty size | sed "s/ .*//")"
HEIGHT=$(($HEIGHT - 5))

LINE=$(ctags --sort=no -x "$1" \
	| fzf --cycle --border --nth=1 --with-nth=1..3 \
	--preview='sh -c "~/scripts/previewer.sh --line {3} {4}"')

[ -z "$LINE" ] && exit 1

echo $LINE | awk '{printf $3}'

