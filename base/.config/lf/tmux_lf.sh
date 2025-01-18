#!/usr/bin/env bash

# A Wrapper for Lf, which sets up some tmux options

# If TMUX is not started, simply start lf
[ -z "$TMUX" ] && exec lf "$@"

tmux set-option default-command "lf"

# Show title set by lf
# When not in an lf pane, show command instead (the default behaviour)
# tmux set-option automatic-rename-format "#{?#{==:#{pane_current_command},lf},#{pane_title},#{pane_current_command}}"
tmux set-option automatic-rename-format "#{?#{m/r:lf|nvim,#{pane_current_command}},#{pane_title},#{pane_current_command}}"
# tmux set-hook -a after-new-window "set-option automatic-rename-format \"#{?#{==:#{pane_current_command},lf},#{pane_title},#{pane_current_command}}\""
tmux set-hook -a after-new-window "set-option automatic-rename-format \"#{?#{m/r:lf|nvim,#{pane_current_command}},#{pane_title},#{pane_current_command}}\""

# Now start lf
exec lf "$@"

