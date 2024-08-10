#!/bin/sh

cat ~/build/unicode_copy/unicode_symbols.txt | tail -n+2 | dmenu -l 20 -c -i -fn "MesloLGS NF:size=16" | awk '{print $1}' | xclip -selection clipboard -f -i -r

