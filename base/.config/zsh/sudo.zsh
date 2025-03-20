# Insert sudo or sudoedit before command

# Code taken and adapted from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/sudo/sudo.plugin.zsh
# Original Authors:
# Dongweiming <ciici123@gmail.com>
# Subhaditya Nath <github.com/subnut>
# Marc Cornellà <github.com/mcornella>
# Carlo Sala <carlosalag@protonmail.com>



__sudo-replace-buffer() {
  local old=$1 new=$2

  if [[ $CURSOR -le ${#old} ]]; then
  # if the cursor is positioned in the $old part of the text, make
  # the substitution and leave the cursor after the $new text
    BUFFER="${new}${BUFFER#$old}"
    CURSOR=${#new}
  else
  # otherwise just replace $old with $new in the text before the cursor
    LBUFFER="${new}${LBUFFER#$old}"
  fi
}

sudo-command-line() {
  local sudocmd="sudo"
  local sudoeditcmd="sudoedit"

  # If line is empty, get the last run command from history
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

  case "$BUFFER" in
    $EDITOR*) __sudo-replace-buffer "$EDITOR" "$sudoeditcmd" ;;
    $sudoeditcmd*) __sudo-replace-buffer "$sudoeditcmd" "$EDITOR" ;;
    $sudocmd*) __sudo-replace-buffer "$sudocmd " "" ;; # This has a slight bug of nothing happening, if the line contains only $sudocmd, but I don't care.
    *) LBUFFER="$sudocmd $LBUFFER" ;;
  esac

  zle redisplay
}

zle -N sudo-command-line
bindkey -M emacs '^S' sudo-command-line
