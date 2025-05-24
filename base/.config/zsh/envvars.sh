#!/bin/sh

#  _____             __     __             
# | ____|_ ____   __ \ \   / /_ _ _ __ ___ 
# |  _| | '_ \ \ / /  \ \ / / _` | '__/ __|
# | |___| | | \ V /    \ V / (_| | |  \__ \
# |_____|_| |_|\_/      \_/ \__,_|_|  |___/

# In this file all Shell and Enviroment Variables are set up.
# Runs very early (most times it is the first thing) on initialization.

# A Helper function, to test if a programm can be run (is installed)
function isInstalled(){
	which "$1" 1&>/dev/null
}

# Overwrite LC_TIME (ly does currently not setup locale correctly, see also https://github.com/fairyglade/ly/issues/278)
export LC_TIME="de_DE.UTF-8"

# === Setup PATH ===
# (avoids dublications)
[[ $PATH =~ $HOME/.local/bin ]] || PATH="$HOME/.local/bin:$PATH"
[[ $PATH =~ $HOME/bin ]] || PATH="$HOME/bin:$PATH"
[[ $PATH =~ $HOME/scripts ]] || PATH="$HOME/scripts:$PATH"

# === Config some programms ===

# LS Colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"
eval "$(dircolors -b ~/.config/zsh/.dircolors)"

export LESS="-R --use-color -i -j.25 -a --mouse"
export WATCH_INTERVAL=1

# Setup FZF
if isInstalled "fzf"; then
	export FZF_DEFAULT_OPTS="--info=inline --reverse --cycle \
	--prompt='❯ ' --pointer='❯' --marker='❯' \
	--color=16,border:8,gutter:-1,spinner:1,prompt:2,pointer:4,header:3,fg+:7,bg+:238 --ansi \
	--bind 'change:top,ctrl-d:half-page-down,ctrl-u:half-page-up,alt-enter:replace-query,alt-p:toggle-preview,alt-s:toggle-sort,ctrl-k:clear-query,ctrl-g:top'"
fi

# === Setup Default applications ===

export EDITOR="nvim"
if isInstalled "emacs"; then
    # Speeds up emacs LSP implementation
    export LSP_USE_PLISTS=true
fi
export PAGER="less"
export BROWSER="firefox"

if isInstalled "alacritty"; then
	export TERMINAL="alacritty"
fi

if isInstalled "kitty"; then
	export TERMINAL="kitty"
fi

# If ssh-agent is running, but no socket was configured assume default socket path
# as specified in user systemd ssh-agent.service file.
# TODO: Check if this is the right thing to do
if pgrep ssh-agent &>/dev/null && [[ -z "$SSH_AUTH_SOCK" ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

if isInstalled "nh"; then
    export NH_OS_FLAKE=~/dotfiles/nixos/
    export NH_HOME_FLAKE=~/dotfiles/home-manager/
fi

# === Change config file locations ===

# Don't set environment variables, if we are NixOS, since some of these need to be set by Nix and are otherwise easily wrong
if [ "$HOST" != "fabians-nix-tuxedo" ]; then

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
isInstalled go && ( [[ $PATH =~ $(go env GOPATH)/bin ]] || PATH="$(go env GOPATH)/bin:$PATH" )
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export KDEHOME="$XDG_CONFIG_HOME/kde"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"
export WORKON_HOME="$XDG_DATA_HOME/virtualenvs"

# Might break
export VSCODE_PORTABLE="$XDG_CONFIG_HOME/vscode"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export SSB_HOME="$XDG_DATA_HOME/zoom"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"

fi

export XINITRC="$XDG_CONFIG_HOME/xinitrc"
export XAUTHORITY="$XDG_CACHE_HOME/Xauthority"
export XCOMPOSECACHE="$XDG_CACHE_HOME/X11/xcompose-cache"

export LESSHISTFILE="-" # Remove Less History File

