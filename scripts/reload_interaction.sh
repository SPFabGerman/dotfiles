#!/bin/sh
# This script can be used to select and reload a lot of programms.

PROG=("Shutdown" "Logout" "Reboot" "Lock" "Suspend" "Hibernate" "Monitors" "Monitors (C)" "Bluetooth (On)" "Bluetooth (Off)" "XP-Pen" "WM => dwm" "WM (K) => dwm" "bspwm (R)" "herbstluftwm (R)"  "WM => bspwm" "WM (K) => bspwm" "WM => Plasma + bspwm" "WM (K) => Plasma + bspwm" "WM => Plasma" "WM (K) => Plasma" "Statusbar (R)" "sxhkd (R)" "Albert" "Picom" "Picom (R)" "Dunst" "Dunst (R)" "X11" "X11 (R)" "Other" "Other (K)")

# Clear cache File, to not interfear with anything
echo "" > ~/.cache/reload_selection.cache

RELCMD="fzf"
if [ -n "$DISPLAY" ]; then
	RELCMD="dmenu -i -c -l 5 -p \"Reload:\""
fi

SEL=$(for ele in "${PROG[@]}";do
echo "$ele"
done | $RELCMD)

case "$SEL" in
	"X11")
		if dmenu_YesNo "Quit X Server?" -NY; then
			echo "" > ~/.cache/reload_selection.cache
			killcurrwm || killall xinit
		fi
		;;
	"X11 (R)")
		if dmenu_YesNo "Reload X Server?" -NY; then
			echo "reload xorg" > ~/.cache/reload_selection.cache
			killcurrwm || killall xinit
		fi
		;;
	"WM => dwm")
		echo "reload wm" > ~/.cache/reload_selection.cache
		echo "dwm" > ~/.cache/currwm.cache
		killcurrwm
		;;
	"WM (K) => dwm")
		echo "reload wm" > ~/.cache/reload_selection.cache
		echo "dwm" > ~/.cache/currwm.cache
		killcurrwm -t
		;;
	"WM => bspwm")
		echo "reload wm" > ~/.cache/reload_selection.cache
		echo "bspwm" > ~/.cache/currwm.cache
		killcurrwm
		;;
	"WM (K) => bspwm")
		echo "reload wm" > ~/.cache/reload_selection.cache
		echo "bspwm" > ~/.cache/currwm.cache
		killcurrwm -t
		;;
	"WM => Plasma + bspwm")
		echo "reload wm" > ~/.cache/reload_selection.cache
		echo "plasma-bspwm" > ~/.cache/currwm.cache
		killcurrwm
		;;
	"WM (K) => Plasma + bspwm")
		echo "reload wm" > ~/.cache/reload_selection.cache
		echo "plasma-bspwm" > ~/.cache/currwm.cache
		killcurrwm -t
		;;
	"WM => Plasma")
		echo "reload wm" > ~/.cache/reload_selection.cache
		echo "plasma" > ~/.cache/currwm.cache
		killcurrwm
		;;
	"WM (K) => Plasma")
		echo "reload wm" > ~/.cache/reload_selection.cache
		echo "plasma" > ~/.cache/currwm.cache
		killcurrwm -t
		;;
	"bspwm (R)")
		bspc wm -r
		;;
	"herbstluftwm (R)")
		herbstclient reload
		;;
	"Statusbar (R)")
		killall dwm_status_bar_time dwm_status_bar_server polybar
		# dwm_status_bar_server &
		# dwm_status_bar_time &;;
		~/.config/polybar/launch.sh
		;;
	"sxhkd (R)")
		pkill -USR1 -x sxhkd
		;;
	"Albert")
		killall albert
		albert &
		;;
	"Picom (R)")
		killall picom
		picom &
		;;
	"Picom")
		killall picom
		;;
	"Dunst (R)")
		killall dunst
		dunst &
		;;
	"Dunst")
		killall dunst
		;;
	"Monitors")
		setup_monitor
		;;
	"Monitors (C)")
		clone_monitor
		;;
	"XP-Pen")
		[ "$(getcurrwm)" = "bspwm" ] && bspc rule -a "st-256color" -o state=floating
		st -e sudo ~/build/xppen/Pentablet_Driver.sh
		;;
	"Logout")
		if dmenu_YesNo "Logout?" -NY; then
			echo "logout" > ~/.cache/reload_selection.cache
			killcurrwm || killall xinit
		fi
		;;
	"Shutdown")
		# TODO: Gracefully exit dwm etc.
		dmenu_YesNo "Shutdown?" -NY && shutdown now
		;;
	"Reboot")
		dmenu_YesNo "Reboot?" -NY && reboot
		;;
	"Suspend")
		systemctl suspend
		;;
	"Lock")
		xlock.sh
		;;
	"Hibernate")
		systemctl hibernate
		;;
	"Bluetooth (On)")
		notify-send "Bluetooth" "$(bluetoothctl -- power on | remove_ansi)" -i ~/.local/share/icons/bluetooth.svg
		;;
	"Bluetooth (Off)")
		notify-send "Bluetooth" "$(bluetoothctl -- power off | remove_ansi)" -i ~/.local/share/icons/bluetooth.svg
		;;
	"Other")
		ps -u "$USER" --no-header | dmenu -i -p "Terminate:" -l 20 | awk '{print $1}' | xargs kill
		;;
	"Other (K)")
		ps -u "$USER" --no-header | dmenu -i -p "Kill:" -l 20 -sb "#d05c65" -nb "#282c34" -sf "#282c34" -nf "#dcdfe4" -c | awk '{print $1}' | xargs kill -9
		;;
esac

