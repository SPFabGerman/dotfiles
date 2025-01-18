#!/usr/bin/env sh

# This Script is a wrapper around the i3 screen locker.

source ~/.cache/wal/colors.sh

i3lock -n -e -f \
    --blur=10 \
    --ring-width 16 \
    --inside-color=${color0}90 \
    --ring-color=${color8}ff \
    --insidewrong-color=${color0}90 \
    --ringwrong-color=${color0}ff \
    --insidever-color=${color7}90 \
    --ringver-color=${color15}ff \
    --line-color=00000000 \
    --keyhl-color=${color15}90 \
    --bshl-color=${color15}90 \
    --separator-color=${color0}ff \
    --greeter-text="󰌾" \
    --greeter-font="MesloLGS Nerd Font Mono" \
    --greeter-size=128 \
    --greeter-color=${color15}ff \
    --greeteroutline-width=4 \
    --greeteroutline-color=${color0}ff \
    --greeter-pos="ix:iy+36" \
    --noinput-text="" \
    --lock-text="" \
    --verif-text="" \
    --wrong-text=""

