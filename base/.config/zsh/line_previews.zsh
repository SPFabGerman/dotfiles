# === Preview Generator Functions ===

# TODO: Cleanup and document code better. Also split this into different functions for normal and global aliases. (Global aliases can be simplified, as a full expansion is much more complicated there.)
alias_preview_expansion () {
	local WORD="$1"
	local ORIG="$WORD"
	local PWORD=""
	local FP=""
	local END=""
	local FINAL=""

	local ISFIRST=1 # Is first word in line
	if [[ "$LBUFFER" = *" "* ]]; then
		ISFIRST=0
	fi

	# Expand alias
	while [[ ("$WORD" != "") && ! ($WORD =~ "^(${(j:|:)no_alias_expand})\$") && ! ("$WORD" =~ '\^\\.*') && ("$PWORD" != "$WORD") ]]; do
		PWORD="$WORD"
		if [[ "$ISFIRST" = 1 ]]; then
			WORD="${aliases[$WORD]}"
		else
			WORD="${galiases[$WORD]}"
		fi
		FP="${WORD%% *}"
		END="${WORD#$FP}$END"
		WORD="$FP"
	done

	if [[ ($WORD =~ "^(${(j:|:)no_alias_expand})\$") ]]; then
		PWORD="$WORD"
	fi

	FINAL="$PWORD$END"
	if [[ "$FINAL" = "$ORIG" ]]; then
		FINAL=""
	fi

	echo "$FINAL"
}

_buffer_quote_for_regex() {
    sed 's/[][\.|$(){}?+*^]/\\&/g' <<< "$*"
}

history_preview () {
    fc -lnr 1 | grep -E "^$(_buffer_quote_for_regex "$BUFFER")" -m 1
}

# === Expansion Functions ===

maybe_expand_history_preview () {
    # Only expand if we are on the far right and see a history preview
    if [[ -z "$RBUFFER" && "$_LINE_PREVIEW_CURRENT" = "history" ]]; then
        _remove_preview
        LBUFFER="$(history_preview)"
    fi
}
zle -N maybe_expand_history_preview



# === Preview Logic ===

_LINE_PREVIEW_CURRENT="none"

_remove_preview () {
    local preview_highlight_key="* memo=line-preview"
    region_highlight[(r)$preview_highlight_key]=()
    unset POSTDISPLAY
    _LINE_PREVIEW_CURRENT="none"
}

_create_line_preview () {
	# Find current word
	local LW=${LBUFFER##* } # Left part of the current word
	local RW=${RBUFFER%% *} # Right part of the current word
	local WORD="${LW}${RW}" # Original Word
    local FINAL=""

    # Remove old preview
    _remove_preview

    # Only expand if we are on a word
    if [[ -n "$WORD" ]]; then
        local APE="$(alias_preview_expansion "$WORD")"
        if [[ -n "$APE" ]]; then
            FINAL=" ($APE)"
            _LINE_PREVIEW_CURRENT="alias"
        fi
    fi

    # Only expand if we don't have an empty line
    if [[ -n "$BUFFER" && -z "$FINAL" ]]; then
        local HP="$(history_preview)"
        if [[ -n "$HP" ]]; then
            # FINAL="$(echo "$HP" | sed -E "s/^$(_buffer_quote_for_regex "$BUFFER")//")"
            FINAL="$(cut -c $(( ${#BUFFER} + 1 ))- <<< "$HP")"
            _LINE_PREVIEW_CURRENT="history"
        fi
    fi

	if [[ "$FINAL" ]]; then
		POSTDISPLAY="$FINAL"
		region_highlight+=("${#BUFFER} $(($#BUFFER + $#POSTDISPLAY)) fg=8 memo=line-preview")
	fi
}

autoload -Uz add-zle-hook-widget
zle -N _remove_preview
zle -N _create_line_preview
add-zle-hook-widget zle-line-pre-redraw _create_line_preview
add-zle-hook-widget zle-line-finish _remove_preview

