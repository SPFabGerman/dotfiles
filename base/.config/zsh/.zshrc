# History setup
HISTFILE="$ZSH_CACHE_DIR/zsh_history"
HISTSIZE=500000
SAVEHIST=100000

# Use emacs key bindings
# (We do this early, since otherwise this might overwrite keybindings set later in the config files.)
bindkey -e

# Load all config files
for config_file ("$ZDOTDIR"/*.zsh(N)); do
  source "$config_file"
done
unset config_file

# Load Prompt
if [[ ! -o login ]]; then
    # eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh-theme-powerlevel.omp.json)"

    # instead use custom enabler, for better integration with rest of shell config
    # (see also omp_prompt_setup.zsh file)
    omp-enable
fi

# Syntax Highlighting has to be loaded last
source /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,underline'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan'
