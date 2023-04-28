#!/bin/bash

# $1 is archive name to mount
AN="$1"
SAN="$(basename "$AN")"
MP="/tmp/archivemount/$SAN/"

mkdir -p "$MP"

archivemount "$AN" "$MP"

lf "$MP"

fusermount -u "$MP"
rmdir "$MP"

# (
# Wait for Backup to be created
# Is the sleep necessary?
sleep 0.5
if test -f "${AN}.orig"; then
    backup --mv "${AN}.orig"
fi
# )&

