# Clean up various unwanted Home-Files on every start of zsh.
# TODO: Find a cleaner solution or move all of that somewhere else (maybe to the login code?)

# Remove leftover bash history file
[ -f "$HOME/.bash_history" ] && rm ~/.bash_history

# Also remove empty(!) dirs:
[ -d "$HOME/.w3m" ] && rmdir "$HOME/.w3m"
[ -d "$HOME/Desktop" ] && rmdir "$HOME/Desktop"
[ -d "$HOME/Music" ] && rmdir "$HOME/Music"
[ -d "$HOME/Videos" ] && rmdir "$HOME/Videos"
[ -d "$HOME/Public" ] && rmdir "$HOME/Public"

