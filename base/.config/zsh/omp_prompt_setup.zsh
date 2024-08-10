# This script is basically a striped down version of `oh-my-posh init zsh`, using only the features that I need and handling the transient prompt better.
export POSH_THEME=/home/fabian/.config/oh-my-posh-theme-powerlevel.omp.json

function omp-precmd() {
  omp_last_error=$?
  omp_stack_count=${#dirstack[@]}
  eval "$(/usr/bin/oh-my-posh print primary --config="$POSH_THEME" --error="$omp_last_error" --stack-count="$omp_stack_count" --eval --shell=zsh --shell-version="$ZSH_VERSION")"
}

function omp-line-init() {
    [[ $CONTEXT == start ]] || return 0

    # Start regular line editor
    (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[1]
    zle .recursive-edit
    local -i ret=$?
    (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[2]

    eval "$(/usr/bin/oh-my-posh print transient --error="$omp_last_error" --stack-count="$omp_stack_count" --config="$POSH_THEME" --eval --shell=zsh --shell-version="$ZSH_VERSION")"
    zle .reset-prompt

    # If we received EOT, we exit the shell
    if [[ $ret == 0 && $KEYS == $'\4' ]]; then
        exit
    fi

    # Ctrl-C
    if (( ret )); then
        zle .send-break
    else
        # Enter
        zle .accept-line
    fi
    return ret
}

function omp-enable() {
    # set secondary prompt
    PS2="$(/usr/bin/oh-my-posh print secondary --config="$POSH_THEME" --shell=zsh)"

    precmd_functions+=(omp-precmd)
    add-zle-hook-widget zle-line-init omp-line-init
}

