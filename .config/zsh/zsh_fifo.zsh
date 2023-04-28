#!/bin/zsh

_zsh_fifo_handler() {
	local line
	if ! read -r -u $1 line; then
		# Remove Handler for FD and close FD
		zle -F $1
		exec {1}<&-
		zle -M "ZSH FIFO was closed"
		if [ "$_ZSH_FIFO_REMOVE_LAST" -ne 0 ]; then
			\rm -f "$_ZSH_FIFO"
		fi
		return 1
	fi

	# Invalidate command line. Needed if revieved commands generate an output.
	zle -I

	eval $line

	# Reset the prompt in a correct way
	# TODO: Find out how to call accept-line from a trap.
	local f
	for f in chpwd $chpwd_functions precmd $precmd_functions; do
		(( $+functions[$f] )) && $f &>/dev/null
	done
	zle reset-prompt
    # zle accept-line
    # zle -U ""

	zle -R
}
zle -N _zsh_fifo_handler

function _zsh_fifo_exit() {
	kill -9 $_ZSH_FIFO_CAT &>/dev/null
	
	if [ "$_ZSH_FIFO_REMOVE" -ne 0 ]; then
		\rm -f "$_ZSH_FIFO" &>/dev/null
	elif [ "$_ZSH_FIFO_REMOVE_LAST" -ne 0 ]; then
		# Use timeout command, sincce it has a different return code for timeouts
		timeout 1s zsh -c read -r -u $_ZSH_FIFO_FD line
		[ "$?" -eq 1 ] && \rm -f "$_ZSH_FIFO" &>/dev/null
	fi
}

if [ "$ZSH_FIFO" ]; then
	if [ -e "$ZSH_FIFO" ]; then
		if ! [ -p "$ZSH_FIFO" ]; then
			echo "ZSH_FIFO is not a FIFO!" 1>&2
			return 1
		fi
	else
		mkfifo -m 0600 "$ZSH_FIFO"
	fi

	# echo "Fifo found"
	local fd
	# Keep the FIFO open for writing
	cat > $ZSH_FIFO &!
	_ZSH_FIFO_CAT="$!"
	exec {fd}<$ZSH_FIFO
	# echo "FD opened"
	zle -Fw $fd _zsh_fifo_handler
	add-zsh-hook zshexit _zsh_fifo_exit
	# echo "Handler installed"

	# Unset Variable, to avoid recursion problems
	_ZSH_FIFO="$ZSH_FIFO"
	_ZSH_FIFO_REMOVE="$ZSH_FIFO_REMOVE"
	_ZSH_FIFO_REMOVE_LAST="$ZSH_FIFO_REMOVE_LAST"
	_ZSH_FIFO_FD="$fd"
	unset ZSH_FIFO ZSH_FIFO_REMOVE ZSH_FIFO_REMOVE_LAST
fi

