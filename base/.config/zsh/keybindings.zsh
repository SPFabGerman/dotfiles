# A Collection of all the Custom Keybindings used
# (The Function does not really need to be loaded now.)

# Use emacs key bindings
bindkey -e

# Some sane default bindings for editing:
# [Shift-Tab] - move backward through completion menu 
bindkey -M emacs "^[[Z" reverse-menu-complete
# [Delete] - delete forward
bindkey -M emacs "^[[P" delete-char
# [Ctrl-Delete] - delete whole word
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M emacs '^H' backward-kill-word
# [Ctrl-K] - Kill while line
bindkey -M emacs '^K' kill-whole-line
# [Ctrl-Arrow] - move wordwise
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M emacs '^[[1;5D' backward-word

right-key-func () {
    maybe_expand_history_preview
    zle forward-char
}
zle -N right-key-func
bindkey -M emacs '^[OC' right-key-func
bindkey -M emacs '^[[C' right-key-func

# [Ctrl+E] - edit cmd-line in vim
autoload edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

better-dot-insert () {
    # TODO: Check if we really have a directory
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N better-dot-insert
bindkey . better-dot-insert

bindkey 'h' run-help

fancy-ctrl-z () {
    zle push-input
    BUFFER="fg"
    zle accept-line
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# [Alt-c] - Copy prev word (good to rename / copy files)
bindkey "^[c" copy-prev-shell-word
