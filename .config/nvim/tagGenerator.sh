#!/bin/sh

ctags -f - "$1" | sed -e '/^__anon.*$/d' -e 's/^\([^	]*\).*\/;"	\(.\).*/syntax keyword Tag_\2 \1/'
# | while read line; do
# 	echo "nvr --remote-send ':$line<CR>'"
# done

