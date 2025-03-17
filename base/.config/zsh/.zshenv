#!/bin/zsh

# Setup ZSH Paths
ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Setup Env Vars
source ~/.config/zsh/envvars.sh

# Disable loading of global zshrc when on NixOS, since it sets up too many conflicting things
if [ -f /etc/NIXOS ]; then
    setopt no_global_rcs
fi
