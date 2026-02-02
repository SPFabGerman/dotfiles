abbr -a ll "ls -la"

abbr -a v "nvim"

abbr -a s 'systemctl'
abbr -a se 'systemctl enable --now'
abbr -a sd 'systemctl disable --now'
abbr -a ss 'systemctl status'
abbr -a slt 'systemctl list-timers --all'
abbr -a su 'systemctl --user'
abbr -a sue 'systemctl --user enable --now'
abbr -a sud 'systemctl --user disable --now'
abbr -a sus 'systemctl --user status'
abbr -a sult 'systemctl --user list-timers --all'

abbr -a ipa "ip addr"
abbr -a ipl "ip link"

abbr -a rm "trash-put"

abbr -a --position anywhere L "| less"
abbr -a --position anywhere G "| grep"
abbr -a --position anywhere ETO '2>&1' # Err to Out
abbr -a --position anywhere OTE '1>&2' # Out to Err
abbr -a --position anywhere ATN '&>/dev/null' # All to null
abbr -a --position anywhere OTN '>/dev/null' # Out to null
abbr -a --position anywhere ETN '2>/dev/null' # Err to null
