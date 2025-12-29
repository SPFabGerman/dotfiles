# Setup for auto alias expand: this array is used in the alias_expand.zsh file.
# Use the function to mark aliases that shouldn't be expanded.
set -A no_alias_expand
function noexpand () {
    no_alias_expand=("$@" $no_alias_expand)
}



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

if isInstalled "nvim"; then
    alias vim='nvim'
    alias v='nvim'
fi

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

alias s='systemctl'
alias se='systemctl enable --now'
alias sd='systemctl disable --now'
alias ss='systemctl status'
alias slt='systemctl list-timers --all'
alias su='systemctl --user'
alias sue='systemctl --user enable --now'
alias sud='systemctl --user disable --now'
alias sus='systemctl --user status'
alias sult='systemctl --user list-timers --all'

alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
noexpand grep

if isInstalled difft; then
    alias diff='difft'
else
    alias diff='diff --color'
    noexpand diff
fi

isInstalled bat && alias cat="bat"

alias rm="trash-put"
alias cp='cp -iv'
alias mv='mv -iv'
alias ln='ln -siv'
alias lnr='ln -r'
alias mkdir='mkdir -pv'
alias pkill='pkill -e'
noexpand cp mv ln mkdir

alias watch="watch -c"
noexpand watch

alias where="builtin whence -cas"
alias which="where"
noexpand where

isInstalled "qmv" && alias qmv='qmv -f do'
noexpand qmv

isInstalled "dust" && alias dust="dust -r"
noexpand dust

if isInstalled "python"; then
    alias py='python'
    alias -s py=python
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

# Some usefull redirections
noexpand --help
alias -g -- --help='--help |& less'
alias -g G='| grep'
alias -g F='| fgrep'
alias -g L='| less'
alias -g ETO='2>&1' # Err to Out
alias -g OTE='1>&2' # Out to Err
alias -g ATN='&>/dev/null' # All to null
alias -g OTN='>/dev/null' # Out to null
alias -g ETN='2>/dev/null' # Err to null

# auto open script files
alias -s sh=bash
alias -s zsh=zsh

# Debugging for zsh
alias path='print -l $path'
alias fpath='print -l $fpath'

## History wrapper
function history {
    # unless a number is provided, show all history events (starting from 1)
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -lE "$@" || builtin fc -lE "$@" 1
}

