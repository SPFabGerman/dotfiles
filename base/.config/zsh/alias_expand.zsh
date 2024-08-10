if [[ "${+no_alias_expand}" -ne 1 ]]; then
    set -a no_alias_expand
    no_alias_expand=()
fi

function ne_alias()
{
    alias $1
    no_alias_expand+=(${1%%\=*})
}

function expand-alias()
{
    PREV=""
    while [[ \
        ($LBUFFER =~ "\<(${(kj:|:)aliases}|${(kj:|:)galiases})\$") && \
        ! ($LBUFFER =~ "\<(${(j:|:)no_alias_expand})\$") && \
        # Avoid expansion when prefixed by a slash
        ! ("$LBUFFER" =~ "\\\\[[:alnum:]]*\$") &&
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

