#!/bin/sh

function trash() {
	# disable globbing
	set -f
	# Set IFS to avoid problems with spaces in filenames
	IFS="$(printf '\n\t')"

	# printf "\n$fx\n"
	printf "Really Trash? [y/N]"
	read ans
	# [ "$ans" = "y" ] && rm -rf $fx
	# Use command to avoid recursion
	[ "$ans" = "y" ] && command trash $fx
}

function backup() {
	# disable globbing
	set -f
	# Set IFS to avoid problems with spaces in filenames
	IFS="$(printf '\n\t')"

	# printf "\n$fx\n"
	printf "Create Backup? [y/N]"
	read ans
	# Use command to avoid recursion
	[ "$ans" = "y" ] && command backup $fx && echo "Backup created!"
}

function jump {
	if [ -n "$1" ]; then
		D="$1"
	else
		D="."
	fi
	DIR=$(bfs "$D" -type d 2>/dev/null | fzf --header='LF - Jump To: ' --preview='$HOME/scripts/previewer.sh {}' --keep-right)
	[ "$DIR" ] && lf -remote "send $id cd \"$DIR\""
}

function search {
	DIR=$(bfs . 2>/dev/null | fzf --header='LF - Jump To: ' --preview='$HOME/scripts/previewer.sh {}' --keep-right)
	[ "$DIR" ] && lf -remote "send $id select \"$DIR\""
}

function link {
	# disable globbing
	set -f
	# Set IFS to avoid problems with spaces in filenames
	IFS="$(printf '\n\t')"

	ln -s -i -t $PWD $fx
}

function img_view {
    IFS="$(printf '\n\t')"
    if [ -n "$fs" ]; then
        # only show selected files
		SEL=$(nsxiv -o -- $fs)
	else
		SEL=$(nsxiv-rifle -o -- "$f")
	fi

	if [ "$SEL" ]; then
		lf -remote "send $id unselect"
		for ITEM in $SEL; do
                lf -remote "send $id glob-select \"$(basename $ITEM)\""
		done
	fi

    # Sleep to avoid bug, where UI freezes up
    sleep 0.1
}

function arc_extract {
    if [[ -n "$TMUX" ]]; then
        tmux split-window -v -d -l 1 arc -folder-safe=false unarchive "$f"
    else
        arc -folder-safe=false unarchive "$f"
    fi
}

function arc_create {
    IFS="$(printf '\n\t')"
    if [[ -n "$TMUX" ]]; then
        tmux split-window -v -l 2 ~/.config/lf/arc_create_interactive.sh $fx
    else
        ~/.config/lf/arc_create_interactive.sh "$fx"
    fi
}

function arc_auto {
    if [ -z "$fs" ]; then
        arc_extract
    else
        arc_create
    fi
}

function arc_mount {
    if [[ -n "$TMUX" ]]; then
        tmux new-window ~/.config/lf/archivemount.sh "$f"
    else
        st -e ~/.config/lf/archivemount.sh "$f" &
    fi
}

function normal_open {
	CUSTOMOPENER="mimeopen"

	MIME="$(mimetype -b "$f")"
	if [[ "$MIME" = "image/"* ]]; then
		img_view
	elif [[ "$MIME" = *"zip"* ]]; then
        arc_mount
	elif [[ -n "$TMUX" ]]; then
		tmux new-window $CUSTOMOPENER "$f"
	else
		$CUSTOMOPENER "$f"
	fi
}

function tmux_open {
	if [[ -n "$TMUX" ]]; then
        # Sleep, to avoid issues when suddenly resizing during initialisation
		tmux new-window ~/.config/lf/sleepdelay.sh "$@" "$f"
	else
		"$@" "$f"
	fi
}

function tmux_open_nofocus {
	if [[ -n "$TMUX" ]]; then
		tmux new-window -d "$@" "$f"
	else
		"$@" "$f"
	fi
}

function tmux_open_setsid {
	if [[ -n "$TMUX" ]]; then
		tmux new-window -d "$@" "$f"
	else
		setsid -f "$@" "$f"
	fi
}

function tmux_open_terminal {
	if [[ -n "$TMUX" ]]; then
		tmux new-window $SHELL
	else
        export LF_LEVEL=""
		setsid -f $TERMINAL -e $SHELL
	fi
}

function shell_tmux {
	if [[ -n "$TMUX" ]]; then
		if ! [ -e "/tmp/lf.$USER.$id.zshfifo" ]; then
			ENV="-e ZSH_FIFO=/tmp/lf.$USER.$id.zshfifo -e ZSH_FIFO_REMOVE=1 -e ZSH_FIFO_REMOVE_LAST=1 -e id=$id"
		fi
		# tmux new-window $SHELL
		tmux split-window -v -l 25% $ENV $SHELL
	else
		$SHELL
	fi
}

function editor_tmux {
	if [[ -n "$TMUX" ]]; then
		ENV="-e id=$id"
		# TODO: Solve with hook and not a wrapper script, if possible
		tmux split-window -h -l 40% $ENV ~/.config/lf/editor_tmux_wrapper.sh "$f"
	else
		$EDITOR "$f"
	fi
}


# === Init ===

function init {
	true
}



# === Main ===

declare -a argarray=()

# Extend tildes
for ((i = 1; i <= $#; i++)); do
	argarray[$i]="${!i/#~/$HOME}"
done

# Run function
"${argarray[@]}"

