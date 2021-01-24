#!/bin/sh

# Outputs a lf command to set the hiddenfiles options, to show only modified files.

echo -n "set hiddenfiles '"
echo -n "$PWD/*"
git status --porcelain | sed -e 's/^.../:!/' -e 's/\/$//' | tr -d '\n'
echo "'"
