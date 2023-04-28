PROMPT_FILLCHAR="═"
PROMPT_FILLCOLOR=8

_PROMPT_FILLER_CMD='$(python3 -c "print(\"$PROMPT_FILLCHAR\"*($COLUMNS), end=\"\")")'

_update_prompt_with_filler () {
    local newline=$'\n'
    PROMPT="%F{$PROMPT_FILLCOLOR}${_PROMPT_FILLER_CMD}%f${newline}${PROMPT}"
}

setup_prompt_filler () {
    precmd_functions=($precmd_functions _update_prompt_with_filler)
}

