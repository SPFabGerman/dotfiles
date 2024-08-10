# Displays an fzf Prompt to select a recent command from the history.
fzf-history() {
  # The awk script removes duplicate lines
  local selected=$(fc -lnr 1 | awk '!a[$0]++' | fzf --height=50% "--query=${BUFFER}" --tiebreak=index --reverse)
  local ret=$?
  if [ -n "$selected" ]; then
	  BUFFER="$selected"
  fi
  zle reset-prompt
  zle end-of-line
  return $ret
}
zle -N fzf-history

