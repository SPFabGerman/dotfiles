#!/bin/bash

# A Breath first search version of find
# Same sytax as normal find (but only one (mandatory) starting point)
# Directories to traverse in can be set with BFS_FIND_EXCLUDE enviroment variable.


# Disable Glob Expansion, to avoid wierd behaviour, when expanding EXCLUDE_STR in find Command!
set -o noglob

queue="$1"
shift

EXCLUDE_STR=""
if [ "$BFS_FIND_EXCLUDE" ]; then
	for dir in ${BFS_FIND_EXCLUDE}; do
		EXCLUDE_STR="$EXCLUDE_STR -name $dir -o"
	done
fi
if [ "$EXCLUDE_STR" ]; then
	EXCLUDE_STR="( ${EXCLUDE_STR%% -o} ) -o"
fi

i=0

while [ -n "$queue" ] && [[ $i -le 10 ]]; do
	echo "$queue" | xargs -I'{DIRS}' -d "\n" find {DIRS} -mindepth 1 -maxdepth 1 "$@"
	queue=$(echo "$queue" | xargs -I'{}' -d "\n" find {} -mindepth 1 -maxdepth 1 -type d \( $EXCLUDE_STR -print \))
	((i++))
done

