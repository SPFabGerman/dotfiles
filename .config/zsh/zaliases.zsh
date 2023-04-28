#          _          _    _ _
#  _______| |__      / \  | (_) __ _ ___  ___  ___
# |_  / __| '_ \    / _ \ | | |/ _` / __|/ _ \/ __|
#  / /\__ \ | | |  / ___ \| | | (_| \__ \  __/\__ \
# /___|___/_| |_| /_/   \_\_|_|\__,_|___/\___||___/

# load normal aliases
source ~/.config/bash/aliases

# Setup for No Expand: add aliases that should not be expanded to this array
set -a no_alias_expand
no_alias_expand=(gcc gdb ls ll cp mv mkdir grep exa dotfiles make --help watch = ip diff du)

alias gprr='git pull --rebase'

alias getKeyCode='showkey -a'
alias al='autoload -Uz'

# Calculations
calc() python3 -c "from math import *; print($*);"
aliases[=]='noglob calc'

# === auto pipes ===
alias -g -- --help='--help |& less'
alias -g G='| grep'
alias -g GG='|& grep'
alias -g F='2>/dev/null | fgrep'
alias -g L='| less'
alias -g LL='|& less'
alias -g NULL='>/dev/null'
alias -g N='>/dev/null'
alias -g NN='&>/dev/null'
alias -g 2N='2>/dev/null'
alias -g CL='--color'
alias -g CLA='--color=always'
alias -g U='| up-exec '
alias W='watch'
alias D='stdindelay'

# === auto open script files ===
alias -s sh=bash
alias -s zsh=zsh
alias -s py=python3

# System Admin shorthands
alias path='print -l $path'
alias fpath='print -l $fpath'

## History wrapper
function history {
  # unless a number is provided, show all history events (starting from 1)
  [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -lE "$@" || builtin fc -lE "$@" 1
}

function stdindelay {
    tmp="$(mktemp)"
    # save stdin and wait for it to finish, befor running cmd
    cat > "$tmp"
    eval "$@" < "$tmp"
    rm -f "$tmp"
}

