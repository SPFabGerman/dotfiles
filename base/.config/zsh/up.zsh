zle-upify() {
    # Trim the whitespace and the last pipe character
    buf="$(echo -n "$BUFFER" | sed 's/[ |]*$//')"

    # Run up and save the output to a temporary file
    tmp="$(mktemp)"
    eval "$buf |& up -o '$tmp' 2>/dev/null"

    # Remove the first shebang line, and trailing newlines
    cmd="$(tail -n +2 "$tmp" | tr -d "\n")"
    rm -f "$tmp"
    
    # Set the current line if necessary
    if [[ -n "$cmd" ]]; then
        BUFFER="$buf | $cmd"
        zle end-of-line
    fi
}

zle -N zle-upify

