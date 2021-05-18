#!/bin/bash

# stty size

if [[ "$(mimetype -b "$1")" =~ ^(image|video|application\/pdf|application\/vnd.*) ]]; then
	stpv "$@"
else
	~/scripts/previewer.sh "$1"
fi

