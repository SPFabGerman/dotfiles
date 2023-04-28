GIT_AUTO_FETCH_INTERVAL=300 #in seconds

# Necessary for the git-fetch-all function
zmodload zsh/datetime zsh/stat

function _git_auto_fetch_update_handler {
	local line
	if ! read -u $1 line; then
        # Remove handler and close fd
		zle -F $1
		exec {1}>&-
        zle -M "Git auto fetch fd error!"
    elif [[ "$line" = "git-auto-fetch-done" ]]; then
        # Remove handler and close fd
		zle -F $1
		exec {1}>&-

        # reset prompt
        zle -I
        local f
        for f in chpwd $chpwd_functions precmd $precmd_functions; do
            (( $+functions[$f] )) && $f &>/dev/null
        done
        zle reset-prompt
        zle -R
    else
        zle -M "Git auto fetch unknown read!"
    fi
}
zle -N _git_auto_fetch_update_handler

function git-fetch-all {
    # Get git root directory
    local gitdir
    if ! gitdir="$(command git rev-parse --git-dir 2>/dev/null)"; then
        return 0
    fi

    # Do nothing if auto-fetch is disabled or we don't have permissions
    if [[ ! -w "$gitdir" || -f "$gitdir/NO_AUTO_FETCH" ]] ||
        [[ -f "$gitdir/FETCH_LOG" && ! -w "$gitdir/FETCH_LOG" ]]; then
            return 0
    fi

    # Get time (seconds) when auto-fetch was last run
    local lastrun="$(zstat +mtime "$gitdir/FETCH_LOG" 2>/dev/null || echo 0)"
    # Do nothing if not enough time has passed since last auto-fetch
    if (( EPOCHSECONDS - lastrun < $GIT_AUTO_FETCH_INTERVAL )); then
        return 0
    fi

    # open pipe and register handler
    local pipe=$(mktemp -u)
    mkfifo $pipe
    local fd
    exec {fd}<>$pipe
    rm $pipe
    zle -Fw $fd _git_auto_fetch_update_handler

    (
        # Fetch all remotes (avoid ssh passphrase prompt)
        date -R &>! "$gitdir/FETCH_LOG"
        GIT_SSH_COMMAND="command ssh -o BatchMode=yes" \
            command git fetch --all 2>/dev/null &>> "$gitdir/FETCH_LOG"
        echo "git-auto-fetch-done" >& $fd
        exec {fd}>&-
    ) &|
}

autoload -Uz add-zle-hook-widget
zle -N git-fetch-all
add-zle-hook-widget zle-line-init git-fetch-all

function git-auto-fetch {
  # Do nothing if not in a git repository
  command git rev-parse --is-inside-work-tree &>/dev/null || return 0

  # Remove or create guard file depending on its existence
  local guard="$(command git rev-parse --git-dir)/NO_AUTO_FETCH"
  if [[ -f "$guard" ]]; then
    command rm "$guard" && echo "${fg_bold[green]}enabled${reset_color}"
  else
    command touch "$guard" && echo "${fg_bold[red]}disabled${reset_color}"
  fi
}

