# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# === Themes and Plugins ===

# Path to oh-my-zsh installation
ZSH="$ZDOTDIR/oh-my-zsh"
ZSH_CUSTOM="$ZSH/custom"
HISTFILE="$ZDOTDIR/.zsh_history"

# Add Custom Folder to fpath, to use for autocompletion
fpath=($ZSH_CUSTOM $fpath)

# Load Theme and Plugins
if [[ ! -o login ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
    plugins=(git command-not-found dirhistory fancy-ctrl-z zsh-autosuggestions sudo fast-syntax-highlighting)
    # git-auto-fetch
else
    # Load reduced subset, if in a login shell, to avoid wierd stuff
    # TODO: change to starship
    ZSH_THEME="af-magic"
    plugins=(git command-not-found dirhistory sudo)
fi

# ZSH_THEME=""
# plugins=()

# === Completion ===

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Use every Completion file, even if it is insecure
ZSH_DISABLE_COMPFIX="true"

# === Updates ===

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# === Misc ===

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Change the command execution time-stamp shown in the history command output.
HIST_STAMPS="dd.mm.yyyy"

# Load additional oh-my-zsh Aliases for cd and ls
# ADDITIONAL_ALIASES="true"

# Auto git fetch Setup
GIT_AUTO_FETCH_INTERVAL=300 #in seconds

# Autosuggestion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true

# === Load ===

# Load Oh-My-ZSH
source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_IGNORE_WIDGETS=($ZSH_AUTOSUGGEST_IGNORE_WIDGETS alias_preview)

# Config P10k, if no config file is available (on zsh startup)
# Otherwise load this config file
[[ -f $ZDOTDIR/.p10k.zsh ]] && source $ZDOTDIR/.p10k.zsh

# Remove Initial Arguments (some plugins set these, for some reason)
unset 1

