# Change working dir in shell to last dir in lf on exit (adapted from ranger).
function lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                zle && zle push-input
                cd "$dir"
                zle && zle accept-line
            fi
        fi
    fi
}
zle -N lfcd
bindkey 'o' lfcd
