#!/bin/sh

# A little wrapper to (re)launch polybar on every Monitor.

PIDS=$(pidof polybar)

BAR="mainbar"
case "$(getcurrwm)" in
	"dwm")
		BAR="dwmbar";;
	"bspwm")
		BAR="bspwmbar";;
	"herbstluftwm")
		BAR="herbstluftbar";;
esac

export MONITOR
polybar -m | sed 's/:.*$//' | while read MONITOR; do
	polybar "$BAR" -c ~/.config/polybar/config.ini -r -q &
done

# Kill old polybar after new one was started, for smoother transition
kill $PIDS

