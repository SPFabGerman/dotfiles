#!/bin/sh

# This Script is a wrapper around the screen locker.

# COLOR=$(xrdb -query | grep '*color15' | sed 's/^*color15:\s#//')
source ~/.cache/wal/colors.sh

i3lock -n -e -f --indicator --clock \
	--color=${color15}90 --inside-color=${color0}90 --ring-color=${color1}90 --insidever-color=${color2}90 --insidewrong-color=${color3}90 --ringver-color=${color1}90 --ringwrong-color=${color1}90 --time-color=${color15}ff --date-color=${color15}ff --verif-color=${color15}ff --wrong-color=${color15}ff --line-uses-ring --ring-width 16

