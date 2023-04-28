#!/bin/bash

# A Breath first search of the whole directory
# Prints out a list of all files under this directory, delimited by NULL Characer.
# The recursion depth is hardcoded and can be set with the MAXDEPTH Variable.
# Set Starting Point with the first paramter
# Directories to traverse in can be set with BFS_FIND_EXCLUDE enviroment variable.

MAXDEPTH=20

# Set right options for glob expansion
shopt -s dotglob  # Set dot expansion for globs
shopt -s nullglob # Always expand *

queue="$1"
shift

if [ "$queue" ]; then
	queue="."
fi

queue="$queue/*"
set -- $queue # Queue is expanded here
i=0

# Loop as long as we have a succesfull expansion
while (($#)) && [[ $i -le $MAXDEPTH ]]; do
	for file; do
		[[ -f "$file" ]] && \
			echo -ne "$file\00"
	done

	queue="$queue/*"
	set -- $queue
	i=$(($i + 1))
done

