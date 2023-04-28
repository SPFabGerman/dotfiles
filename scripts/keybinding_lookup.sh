#!/bin/sh

# This script can be used to look up keybindings in dmenu.
# It reads the ~/keybinding_lookup.md File.
# It doesn't matter what you select. Nothing happens.

grep '^|' ~/Notes/keybinding_lookup.md | dmenu -c -l 10 -i

