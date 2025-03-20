# Setup for auto alias expand: this array is used in the alias_expand.zsh file.
# Use the function to mark aliases that shouldn't be expanded.
set -A no_alias_expand
function noexpand () {
    no_alias_expand=("$@" $no_alias_expand)
}



function generate-bookmark-aliases () {
    # This is a function, so that variables remain local and aliases can be updated later manually.
    [[ -f ~/.config/bookmarks ]] && sed '/^$/d' ~/.config/bookmarks | while read line; do
        local M="$(echo "$line" | cut -d " " -f 1)"
        local D="$(echo "$line" | cut -d " " -f 2)"
        alias b${M}="cd ${D}"
    done
}
generate-bookmark-aliases

# Reset Shell
alias esh='exec $SHELL'

isInstalled doas && alias sudo='doas'

# Cleaner ls
if isInstalled "eza"; then
    alias eza='eza -F --icons --group-directories-first -h'
    alias exa='eza'
    alias ls='eza'
    noexpand eza ls
fi
alias ll='ls -la'
alias lt='ls -lT'
alias lT='ls -laT'

isInstalled "nvim" && alias vim='nvim'

if isInstalled "pacman"; then
    alias pm='pacman'
    alias pms='sudo pacman -S'
    alias pmss='pacman -Ss'
    alias pmsi='pacman -Si'
    alias pmsu='sudo pacman -Syu'
    alias pmr='sudo pacman -Rs'
    alias pmq='pacman -Q'
    alias pmqs='pacman -Qs'
    alias pmqi='pacman -Qi'
    alias pmf='pacman -F'
    alias pmfl='pacman -Fl'
fi

alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias diff='diff --color'
noexpand grep diff

alias rm="trash-put"
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -siv'
alias lnr='ln -r'
alias mkdir='mkdir -pv'
noexpand cp mv ln mkdir

alias watch="watch -c"
noexpand watch

function show() {
    command eza -l --no-user --no-time --no-permissions --no-filesize $(which $1)
}

isInstalled "qmv" && alias qmv='qmv -f do'
noexpand qmv

isInstalled "dust" && alias dust="dust -r"
noexpand dust

if isInstalled "python3"; then
    alias python='python3'
    alias py='python3'
    alias -s py=python3
fi

if isInstalled "xclip"; then
    function clipcopy() { xclip -in -selection clipboard < "${1:-/dev/stdin}"; }
    function clippaste() { xclip -out -selection clipboard; }
elif isInstalled "xsel"; then
    function clipcopy() { xsel --clipboard --input < "${1:-/dev/stdin}"; }
    function clippaste() { xsel --clipboard --output; }
fi

if isInstalled "gcc"; then
    alias gcc='gcc -Wall'
    alias gdb='gdb -q'
    noexpand gcc gdb
fi

alias ipa='ip addr'
alias ipl='ip link'

# === auto pipes ===
noexpand --help
alias -g -- --help='--help |& less'
alias -g G='| grep'
alias -g GG='|& grep'
alias -g F='2>/dev/null | fgrep'
alias -g L='| less'
alias -g LL='|& less'
alias -g N='>/dev/null'
alias -g NN='&>/dev/null'
alias -g 2N='2>/dev/null'

# === auto open script files ===
alias -s sh=bash
alias -s zsh=zsh

isInstalled nix-instantiate && alias -s nix='nix-instantiate --eval --strict'

# Debugging for zsh
alias path='print -l $path'
alias fpath='print -l $fpath'

## History wrapper
function history {
    # unless a number is provided, show all history events (starting from 1)
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -lE "$@" || builtin fc -lE "$@" 1
}

