# History setup
HISTFILE="$ZSH_CACHE_DIR/zsh_history"
HISTSIZE=500000
SAVEHIST=100000

# Load all config files
for config_file ("$ZDOTDIR"/*.zsh(N)); do
  source "$config_file"
done
unset config_file

# Load Prompt
if [[ ! -o login ]]; then
    # eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh-theme-powerlevel.omp.json)"
    # enable transientprompt manually, to not overwrite hooks
    # add-zle-hook-widget zle-line-init _posh-zle-line-init # enable_poshtransientprompt

    # use custom enabler, for better integration with rest of shell config
    # (see also omp_prompt_setup.zsh and prompt_filler.zsh file)
    omp-enable
    setup_prompt_filler
else
    # On Login shells load starship
    # eval "$(starship init zsh)"
fi

# Load Syntax Highlighting last, since otherwise it interferes with alot of stuff
source "$ZDOTDIR/F-Sy-H/F-Sy-H.plugin.zsh"

# Remove arguments, that have remained from somewhere
shift $#
