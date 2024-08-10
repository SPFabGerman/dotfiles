#     _    _ _
#    / \  | (_) __ _ ___  ___  ___
#   / _ \ | | |/ _` / __|/ _ \/ __|
#  / ___ \| | | (_| \__ \  __/\__ \
# /_/   \_\_|_|\__,_|___/\___||___/

# Setup for Auto Expand: add aliases that should not be expanded to this array
set -a no_alias_expand
no_alias_expand=(gcc gdb ls cp mv grep eza dotfiles make --help watch diff dust qmv)

# Source Fast CD Aliases
eval "$(generate_bookmark_aliases bash)"

# Reset Shell
alias esh='exec $SHELL'

# Fast Sudo
alias _!='doas !!'

isInstalled doas && alias sudo='doas'

# basic dotfiles alias
if [ -d "$HOME/.dotfiles.git" ]; then
	alias dotfiles="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"
	alias dot="dotfiles"
fi

# Cleaner ls
if isInstalled "eza"; then
	alias eza='eza -F --icons --group-directories-first -h'
    alias exa='eza'
	alias ls='eza'
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

alias rm="trash-put"
# TODO: Maybe add -v to the next ones to have verbose output in terminal?
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'
alias md='mkdir'
alias rd='rmdir'
alias ln='ln -si'
alias lnr='\ln -sir'
# alias du='du -h'

alias watch="watch -c -n 1"

isInstalled "qmv" && alias qmv='qmv -f do'

# Find files
# alias fd='find . -type d -name'
# alias ff='find . -type f -name'
isInstalled "fd" && alias find='fd'

if isInstalled "dust"; then
    alias du="dust"
    alias dust="dust -r"
fi

if isInstalled "python3"; then
	alias python='python3'
	alias py='python3'
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
fi

# Single Letter aliases
alias l='ls'
alias c='cd'
function cl(){ cd $1; ls }
function mkcd() { mkdir -p $@ && cd ${@:$#} }
alias v='vim'
alias e='emacs'
alias hd='hexdump'
alias od='objdump'

isInstalled "colormake" && alias make='colormake'
alias m='make'
alias mc='make clean'
alias ma='make all'
alias mca='make clean all'

# systemd controll
if isInstalled "systemctl"; then
    alias sys='systemctl --user'
    alias ssys='doas systemctl'
    alias syssa='systemctl --user start'
    alias ssyssa='doas systemctl start'
    alias sysst='systemctl --user stop'
    alias ssysst='doas systemctl stop'
    alias sysr='systemctl --user restart'
    alias ssysr='doas systemctl restart'
    alias syse='systemctl --user enable'
    alias ssyse='doas systemctl enable'
    alias sysd='systemctl --user disable'
    alias ssysd='doas systemctl disable'
fi

alias ipa='ip addr'
alias ipl='ip link'

alias getKeyCode='showkey -a'

# === auto pipes ===
alias -g -- --help='--help |& less'
alias -g G='| grep'
alias -g GG='|& grep'
alias -g F='2>/dev/null | fgrep'
alias -g L='| less'
alias -g LL='|& less'
alias -g N='>/dev/null'
alias -g NN='&>/dev/null'
alias -g 2N='2>/dev/null'
alias -g CL='--color'
alias -g CLA='--color=always'
alias W='watch'

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

