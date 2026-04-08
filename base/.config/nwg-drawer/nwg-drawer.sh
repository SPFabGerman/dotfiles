#!/usr/bin/env bash

nwg-drawer -nofs -nocats -term kitty -c 10 \
  -pbuseicontheme -pblock "swaylock" -pbpoweroff "systemctl poweroff" -pbreboot "systemctl reboot" \
  "$@"
