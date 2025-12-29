#!/bin/zsh

_follow_cwd_of_pid_handler() {
	local line
	if ! read -r -u $1 line; then
		# Remove Handler for FD and close FD
		zle -F $1
        exec {myfd}>&-
		return 1
	fi

    # Do nothing if directory has not changed
    if [[ "$PWD" = "$line" ]]; then
        return 0
    fi

	cd "$line"

    # Reset the prompt (run all hooks that would have also been run at the initialisation of the prompt)
	local f
	for f in chpwd $chpwd_functions precmd $precmd_functions; do
		(( $+functions[$f] )) && $f &>/dev/null
	done
	zle reset-prompt
}
zle -N _follow_cwd_of_pid_handler 


if [ "$ZSH_FOLLOW_CWD_OF_PID" ]; then
    # Create file descriptor, send cwd of process to it and install handler for it
    integer myfd
    exec {myfd}< <(while readlink -e /proc/$ZSH_FOLLOW_CWD_OF_PID/cwd; do sleep 1; done)
    zle -Fw $myfd _follow_cwd_of_pid_handler

	# Unset Variable, to avoid recursion problems
	unset ZSH_FOLLOW_CWD_OF_PID
fi

