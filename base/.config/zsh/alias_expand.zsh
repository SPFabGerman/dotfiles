if [[ "${+no_alias_expand}" -ne 1 ]]; then
    set -A no_alias_expand
fi

function expand-alias()
{
    # TODO Bug: This fails if arguments are present in an alias expansion
    PREV=""
    while [[ \
        ($LBUFFER =~ "\<(${(kj:|:)aliases}|${(kj:|:)galiases})\$") && \
        ! ($LBUFFER =~ "\<(${(j:|:)no_alias_expand})\$") && \
        # Avoid expansion when prefixed by a slash
        ! ("$LBUFFER" =~ "\\\\[[:alnum:]]*\$") && \
        # Cancel expansions, when we are not after a command
        ("$LBUFFER" != "$PREV") ]]; do
        
        PREV="$LBUFFER"
        zle _expand_alias
        # Remove Trailing space from alias expansion
        LBUFFER="${LBUFFER% }"
    done
}

function expand-alias-full()
{
    zle _expand_alias
    # expand word can bug sometimes, therefor not included in normal function
    zle expand-word
}

zle -N expand-alias
zle -N expand-alias-full

space-key-func () { expand-alias; zle self-insert }
zle -N space-key-func
enter-key-func () { expand-alias; zle accept-line }
zle -N enter-key-func
bindkey -M emacs ' ' space-key-func
bindkey -M emacs '^M' enter-key-func
bindkey -M emacs '^ ' self-insert # [Control-Space] to bypass completion
bindkey -M isearch " " self-insert # normal space behaviour during searches
bindkey -M emacs '^[^E' expand-alias-full
