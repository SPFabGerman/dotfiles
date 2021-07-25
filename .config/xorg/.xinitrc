#!/bin/sh

# === Initial Setup ===

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Set Keyboard Layout
setxkbmap de
# Change some annyoing keys
xmodmap -e 'keysym Caps_Lock = Shift_L' # Caps Lock to shift
xmodmap -e 'keysym dead_circumflex = asciicircum degree' # Only one tap needed for circumflex
xmodmap -e 'keycode 21 = grave acute' # Change Grave order

xsetroot -cursor_name left_ptr

setup_monitor --nobg &

# Update Background Queue and set Background
(find ~/wallpapers/ -type f | shuf -n 9 | xargs -d '\n' queuebg; swapbg 1) &
# setbg &

# Initialize key deamon
# (Automatically unlocks default keyring, if password is login password)
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

# First, kill off any old, leftover Programm
TOKILL=(picom dwm_status_bar_server dwm_status_bar_time sxhkd xss-lock polybar albert kupfer ulauncher srandrd dunst udiskie xob bspc bspwm_swallow bspwm_albert_focus)
killall ${TOKILL[@]}

# === MAIN LOOP ===
# start wm and reload if desired
SEL="reload wm"
while [ "$SEL" = "reload wm" ]; do
	echo "" > ~/.cache/reload_selection.cache
	# WM="$(cat ~/.cache/currwm.cache)"
	WM="bspwm"
	WMEXEC=""
	WMPID="-1"

	xsetroot -name ""

	# === Programms for every wm ===
	(tail -f ~/.config/xob/xobfifo | xob) &
	sxhkd &
	echo ~/.config/sxhkd/sxhkdrc | entr -nps "pkill -USR1 -x sxhkd; notify-send \"SXHKD reloaded\" -u low" &
	DESKTOP_SESSION=gnome albert -k F14 &
	srandrd -n setup_monitor &
	xss-lock -- xlock.sh &
	udiskie -s &

	# === WM Specific ===
	case "$WM" in
		"dwm")
			picom &
			dunst &
			# WMEXEC="dwm 1>~/.cache/logs/dwm.out 2>~/.cache/logs/dwm.err"
			WMEXEC="dwm"
			;;
		"bspwm")
			picom &
			dunst &
			sxhkd -c ~/.config/sxhkd/sxhkdrc_bspwm &
			echo ~/.config/sxhkd/sxhkdrc_bspwm | entr -nps "pkill -USR1 -x sxhkd; notify-send \"SXHKD reloaded\" -u low" &
			WMEXEC="bspwm"
			;;
		"plasma")
			export DESKTOP_SESSION=plasma
			WMEXEC="startplasma-x11"
			;;
		"plasma-bspwm")
			export DESKTOP_SESSION=plasma
			export KDEWM=/usr/bin/bspwm
			picom &
			sxhkd -c ~/.config/sxhkd/sxhkdrc_bspwm &
			echo ~/.config/sxhkd/sxhkdrc_bspwm | entr -nps "pkill -USR1 -x sxhkd; notify-send \"SXHKD reloaded\" -u low" &
			WMEXEC="startplasma-x11"
			;;
		"emacs")
			picom &
			dunst &
			WMEXEC="emacs"
			;;
	esac

	# === Programm specific ===
	if pidof dunst &>/dev/null; then
		echo ~/.config/dunst/dunstrc | entr -nps "killall dunst; dunst & sleep .5; notify-send \"Dunst reloaded\" -u low" &
	fi

	# === Start WM ===
	$WMEXEC &
	WMPID="$!"

	# === Post Hooks ===
	case "$WM" in
		"dwm")
			~/.config/polybar/launch.sh &
			;;
		"bspwm")
			~/.config/polybar/launch.sh &
			;;
	esac

	wait "$WMPID"

	# === Cleanup ===
	killall ${TOKILL[@]}
	sleep 0.1 # This neeeds to be done, to prevent a crash when restarting dwm
	SEL=$(cat ~/.cache/reload_selection.cache)
done

