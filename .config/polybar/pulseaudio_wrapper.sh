#!/bin/sh

COLORMUTE="$(xrdb -query | awk '/\*.color8:/{print $2}' | sed 's/#//')"
export COLORBOX="$(xrdb -query | awk '/alpha_color3:/{print $2}')"
export COLORRESET="$(xrdb -query | awk '/alpha_color15:/{print $2}')"

pulseaudio-control \
	--format '%{B$COLORBOX} %{T2}$SINK_NICKNAME%{T-} %{B$COLORRESET} ${VOL_LEVEL}% %{B-}' \
	--color-muted "$COLORMUTE" \
	--sink-nickname "alsa_output.pci-0000_00_1f.3.analog-stereo":"墳" \
	--sink-nickname "alsa_output.pci-0000_00_1f.3.analog-stereo"/"analog-output-headphones":"" \
	--sink-nickname "bluez_sink.EB_06_EF_84_65_CD.a2dp_sink":"" \
	listen

