# Make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start () { echoti smkx }
    function zle_application_mode_stop () { echoti rmkx }
    zle -N zle_application_mode_start
    zle -N zle_application_mode_stop
    add-zle-hook-widget zle-line-init zle_application_mode_start
    add-zle-hook-widget zle-line-finish zle_application_mode_stop
fi

