#!/bin/sh

TAGNORM=("" "" "" "" "" "" "" "" "")
TAGUSE=("" "" "" "" "" "" "" "" "")
TAGOCC=("" "" "" "" "" "" "" "" "")

function getSymbol() {
	# $1 is Window ID

	# NAME=$(xprop -notype -id "$1" _NET_WM_NAME)
	# NAME=${NAME#_NET_WM_NAME = }

	CLASS=$(xprop -notype -id "$1" WM_CLASS)
	CLASS=${CLASS#WM_CLASS = }

	case "$CLASS" in
		*"st-256color"*)
			echo "";;
        *"Alacritty"*)
            echo "";;
		*"emacs"*)
			echo "";;
		*"firefox"*)
			echo "爵";;
		*"Thunderbird"*)
			echo "";;
		*"Mailspring"*)
			echo "";;
		*"telegram-desktop"*)
			echo "";;
		*"discord"*)
			echo "ﭮ";;
		*"FoxitReader"*)
			echo "";;
		*"zathura"*)
			echo "";;
		*"Evince"*)
			echo "";;
		*"typora"*)
			echo "";;
		*"zoom"*)
			echo "";;
		*"mpv"*)
			echo "懶";;
		*"spotify"*)
			echo "";;
		*"xournalpp"*)
			echo "";;
		*"Steam"*)
			echo "";;
			# echo "";;
		*)
			return 1;; # Default case: Error if no correct symbol was found
	esac

	return 0
}

