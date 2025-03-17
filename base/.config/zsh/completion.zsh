# setup completion dumps
ZSH_COMPDUMP="$ZSH_CACHE_DIR/zcompdump-${HOST}-${ZSH_VERSION}"

# Setup fpath
fpath=("$ZDOTDIR/custom-completions" $fpath)


autoload -U compinit
compinit -d "$ZSH_COMPDUMP"

# automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit

# TODO: I don't think this does anything useful. Remove it.
# zmodload -i zsh/complist


# setup caches
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

# Set basic completion options
unsetopt flowcontrol # ???
# setopt complete_in_word
setopt always_to_end
setopt no_beep

# TODO: What is this doing?
zstyle '*' single-ignored show

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"
if [[ "$CASE_SENSITIVE" = true ]]; then
  zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
else
  if [[ "$HYPHEN_INSENSITIVE" = true ]]; then
    zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
  else
    zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
  fi
fi
unset CASE_SENSITIVE HYPHEN_INSENSITIVE


# Setup Menu and Group Completion
setopt auto_menu # (default) enable menu navigation
setopt menu_complete # ... and immediately go into it after starting completion
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{8}░▒▓%f%K{8}%B %d %b%k%F{8}%f'

# show some nice messages from completions
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# my custom completion wrapper
COMPLETION_ACTIVE=0
complete-with-dots () {
    COMPLETION_ACTIVE=1
    _stop_line_preview

    # turn off line wrapping and Show dots when waiting for completion
    printf '\e[?7l%s\e[?7h' "[38;5;7m…[00m"
    # zle expand-or-complete
    zle complete-word
    zle redisplay

    COMPLETION_ACTIVE=0
    _start_line_preview
}
zle -N complete-with-dots
bindkey -M emacs "^I" complete-with-dots
bindkey -M viins "^I" complete-with-dots
bindkey -M vicmd "^I" complete-with-dots

# Some Pretty colors for files
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"

# some better looking processes
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,comm -w -w"
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;32=0'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;31=0'

# better man page completion
zstyle ':completion:*:manuals.*' insert-sections true
zstyle ':completion:*:manuals' separate-sections true

# Better directory completion
zstyle ':completion:*' special-dirs true # Complete . and .. special directories
zstyle ':completion:*' squeeze-slashes true # don't treat // as /*/
unsetopt auto_remove_slash # don't remove directory slashes after completion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:cd:*' complete-options true # Show options for cd

zstyle ':completion:*' completer _expand _complete

# === Custom Completion Definitions ===

compdef _gnu_generic xdragon
compdef _gnu_generic pplatex ppdflatex
compdef _gnu_generic apack aunpack als acat adiff arepack
compdef colormake=make

# Better ordering for make
zstyle ':completion:*:make::' group-order targets '*' variables
zstyle ':completion:*:colormake::' group-order targets '*' variables

