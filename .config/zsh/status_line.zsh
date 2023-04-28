get_current_shell_word () {
    local lba=( ${(z)LBUFFER} ) # Split left part of buffer into shell words

    if [[ "${LBUFFER[-1]}" == " " && "${${lba[-1]}[-1]}" != " " ]]; then
        # last space does not belong to shell word -> cursor is over next word
        local rba=( ${(z)RBUFFER} )
        local sw="${rba[1]}"
    else
        # cursor is in the middle of a shell word -> expand with right buffer
        local rb="${lba[-1]}${RBUFFER}"
        local rba=( ${(z)rb} )
        local sw="${rba[1]}"
    fi

    echo "$sw"
}


_fileglob_preview () {
    emulate -L zsh -o NULL_GLOB

    local WORD="$(get_current_shell_word)"
    local WORD="${WORD/\\ / }" # Remove backslashes, since they prevent globbing
    [[ -z "$WORD" ]] && return 0
    [[ "$WORD" == *\*\** ]] && return 0 # do not expand words containing **, since it usually takes to much time!

    local EXPANSION=( ${~WORD} ) 2>/dev/null
    [[ "$?" -ne 0 ]] && return 0
    [[ -z "$EXPANSION" ]] && return 0
    [ "$WORD" = "$EXPANSION" ] && return 0
    [ -e "${EXPANSION[1]}" ] || return 0 # Check if file exists (important when only the ~ is expanded)

    export COLUMNS
    exa -d -G --icons --color=never ${EXPANSION[@]} 2>/dev/null | head -n 5
}

_OLDSTATUS=""
_create_status () {
    if [[ "${COMPLETION_ACTIVE}" == 1 ]]; then
        return 0
    fi

    # zle -M "$(_expand)"
    # return 0

    local STATUS=""
    STATUS="$(_fileglob_preview)"

    if [ "$STATUS" != "$_OLDSTATUS" ]; then
        zle -M "$STATUS"
    fi

    _OLDSTATUS="$STATUS"
}
zle -N _create_status

autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-pre-redraw _create_status

