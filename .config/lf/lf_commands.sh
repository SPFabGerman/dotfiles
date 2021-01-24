#!/bin/sh

function trash() {
	# disable globbing
	set -f
	# Set IFS to avoid problems with spaces in filenames
	IFS="$(printf '\n\t')"

	# printf "\n$fx\n"
	printf "Really Trash? [y/N]"
	read ans
	# Use command to avoid recursion
	# [ "$ans" = "y" ] && rm -rf $fx
	[ "$ans" = "y" ] && command trash $fx
}

function jump {
	if [ "$1" ]; then
		D="$1"
	else
		D="."
	fi
	DIR=$(bfs_find "$D" -type d 2>/dev/null | fzf --header='LF - Jump To: ' --preview='$HOME/scripts/previewer.sh {}' --keep-right)
	[ "$DIR" ] && lf -remote "send $id cd \"$DIR\""
}

function search {
	DIR=$(bfs_find . 2>/dev/null | fzf --header='LF - Jump To: ' --preview='$HOME/scripts/previewer.sh {}' --keep-right)
	[ "$DIR" ] && lf -remote "send $id select \"$DIR\""
}

function link {
	# disable globbing
	set -f
	# Set IFS to avoid problems with spaces in filenames
	IFS="$(printf '\n\t')"

	ln -s -i -t $PWD $fx
}

function normal_open {
	MIME="$(mimetype -b "$f")"
	if [[ "$MIME" = "image/"* ]]; then
		lf -remote "send $id img_view"
	elif [[ -n "$TMUX" ]]; then
		tmux new-window mimeopen "$f"
	else
		mimeopen "$f"
	fi
}

function tmux_open {
	if [[ -n "$TMUX" ]]; then
		tmux new-window "$@" "$f"
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

function shell_tmux {
	if [[ -n "$TMUX" ]]; then
		if ! [ -e "/tmp/lf.$USER.$id.zshfifo" ]; then
			ENV="-e ZSH_FIFO=/tmp/lf.$USER.$id.zshfifo -e ZSH_FIFO_REMOVE=1 -e ZSH_FIFO_REMOVE_LAST=1"
		fi
		# tmux new-window $SHELL
		tmux split-window -v -l 25% $ENV $SHELL
	else
		$SHELL
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

