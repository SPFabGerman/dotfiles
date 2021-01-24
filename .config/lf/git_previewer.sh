#!/bin/sh

# Skip if not inside Work Tree
if [ ! "$(git $GIT_OPTIONS rev-parse --is-inside-work-tree 2>&1)" = "true" ]; then
    echo "Not in a Git Repository!"
    exit 1
fi

git_status=$(git $GIT_OPTIONS status -u --ignored --porcelain $1)
git_root=$(git $GIT_OPTIONS rev-parse --show-toplevel)

# Strip Git Root Prefix from Filename
file=$(echo "$1" | sed "s|$git_root/||")

# Define Color Codes
red="\x1b[31m"
green="\x1b[32m"
reset_color="\x1b[0m"

# Extract State of Workspace and Index
if [ -z "$git_status" ]; then
    index_state=" "
    workspace_state=" "
else
    index_state=${git_status:0:1}
    workspace_state=${git_status:1:1}
fi

[ "$index_state" = " " ] && index_state="-"
[ "$workspace_state" = " " ] && workspace_state="-"

# Change Color of file name, if modified
color=$reset_color
[ ! "$index_state" = "!" ] && [ ! "$index_state" = "-" ] && color=$green
[ ! "$workspace_state" = "!" ] && [ ! "$workspace_state" = "-" ] && color=$red

# Display State
echo -e "${color}${file}${reset_color}"
echo "Index:     $index_state"
echo "Workspace: $workspace_state"
echo ""

# Show Git Diff since last commit
# And try to reduce Header
git $GIT_OPTIONS diff --color --color-words -U1 --ignore-space-change --ignore-blank-lines HEAD $file \
    | sed -e '/index/d' -e '/diff \-\-git/d' -e '/\(+++\|---\) \(a\|b\)/d' -e '/@@.*@@/d'

