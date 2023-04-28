#!/bin/sh

COLORMUTE="$(xrdb -query | awk '/\*.color8:/{print $2}' | sed 's/#//')"
export COLORBOX="$(xrdb -query | awk '/alpha_color3:/{print $2}')"
export COLORRESET="$(xrdb -query | awk '/alpha_color15:/{print $2}')"

pulseaudio-control \
    --format '%{B$COLORBOX}%{T7} %{T2}$SINK_NICKNAME%{T-}%{T7} %{B$COLORRESET} %{T-}${VOL_LEVEL}%%{T7} %{B-}' \
    --color-muted "$COLORMUTE" \
    --sink-nickname "alsa_output.*.analog-stereo"/"analog-output-headphones":"" \
    --sink-nickname "alsa_output.*.analog-stereo":"墳" \
    --sink-nickname "bluez_sink.*.a2dp_sink":"" \
    listen

