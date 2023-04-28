## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt share_history          # share command history data
setopt nobanghist             # don't do history expansion

# recognize comments in interactive shell
setopt interactivecomments

# more verbose job output
setopt long_list_jobs

# enable prompt substitution
setopt prompt_subst

