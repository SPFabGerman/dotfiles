#!/bin/bash

STATE="$(playerctl -s status)" 
if [[ "$?" -ne 0 ]]; then
    exit 1
elif [[ "$STATE" == "Playing" ]]; then
    echo "%{T2}契%{T-}%{T7} "
elif [[ "$STATE" == "Paused" ]]; then
    echo "%{T2}%{T-}%{T7} "
elif [[ "$STATE" == "Stopped" ]]; then
    echo "%{T2}栗%{T-}%{T7} "
else
    echo "?%{T-}%{T7} "
fi

