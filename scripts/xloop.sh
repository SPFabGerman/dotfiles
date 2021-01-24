#!/bin/sh
# This script starts Xorg Server in a Loop, to enable reloading, if desired.
# It looks at the text of a temp cache file, to determine if to reload.
# The Text is set by reload_interaction script.

SEL="reload xorg"

while [ "$SEL" = "reload xorg" ]; do
    # Clear Cache File (just for safety)
    echo "" > ~/.cache/reload_selection.cache
    startx ~/.config/xorg/.xinitrc
    SEL=$(cat ~/.cache/reload_selection.cache)
done

