#!/bin/sh

# This Script is a wrapper around the screen locker.

# COLOR=$(xrdb -query | grep '*color15' | sed 's/^*color15:\s#//')
source ~/.cache/wal/colors.sh

i3lock -n -e -f --indicator --clock \
	--color=${color15}90 --insidecolor=${color0}90 --ringcolor=${color1}90 --insidevercolor=${color2}90 --insidewrongcolor=${color3}90 --ringvercolor=${color1}90 --ringwrongcolor=${color1}90 --timecolor=${color15}ff --datecolor=${color15}ff --verifcolor=${color15}ff --wrongcolor=${color15}ff --line-uses-ring --ring-width 16

