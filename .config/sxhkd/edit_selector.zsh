#!/bin/zsh

# This script allows the user to search and select a file via fzf and then opens this file in an editor for further inspection / editing.
# If the first argument is "--stay" the script will not change the Working Directory to the file.

# Filter out git and cache Directories and log files as well as binary files (via the grep)
FILE=$(bfs . \
    -type d \( -name '*.git' -o -iname '*trash*' \) -prune \
    -o -type f -print 2>/dev/null \
     | fzf --keep-right --cycle --tiebreak=length,end \
         --preview="~/scripts/previewer.sh {}" \
         --header " $(pwd):")

[ -z "$FILE" ] && exit 1
[ -f "$FILE" ] || exit 1

if [ "$1" = "--stay" ] || [ "$1" = "-s" ]; then
    eval exec $EDITOR "$FILE"
else
    # Switch working directory to file
    cd $(dirname $FILE)
    # If you ask, yes "eval exec" is necessary, to correctly evaluate the EDITOR String.
    # (eval makes sure the quotes in the variable are respected (because why would bash do that on it's own?!?!) and exec replaces the current process afterwards)
    eval exec $EDITOR "$(basename $FILE)"

    # mimeopen "$(basename "$FILE")"
fi

