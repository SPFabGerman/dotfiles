# Dotfiles TODOs

- Add a Readme

## Things to try out
- Serious Neovim setup
- Wayland with Niri or Cosmic Desktop

## NixOS
- Maybe disable channels entirely?
- make nix store it's own partition, so that it is reusable by other operating systems
- Push pplatex changes

## ZSH
- Go through defined options and clean some up
- Simplify line above prompt to avoid visual issues when resizing
- Check that no aliases are used in init files; define aliases only at end and disable alias expansion for initialization
- Seperate code used by zshrc and zshenv, to avoid double loading
- Make forward slash (and maybe other things too) a word seperator

- Maybe try out zoxide?
- Maybe try out zsh-autocomplete?

## Fish
- Add preview for abbreviations
- Add CWD follower

## Kitty
- Setup shell integration

## LF
Config changes:
- Free up hjkl keys for movement
- Add a way to toggle numbers for faster jumps
- Check out different modes?

Code Fixes:
- Optimize calcdirsize by also saving values for subdirs
- Fix calcdirsize aborting on one unreadable file (maybe with an option to either abort with error, ignore silently or somehow inform the user?)
- Add configurable timeout for automatic calcdirsize operations
- Add on-cd to on-init to documentation
- Add error information to logs (particularly from parsing rulerfile)
- When in command mode and hitting / switch to search, for parity with $ etc. (but this breaks current backspace behaviour of /)
- Maybe talk about deprecating setfilter, as it can be trivially achieved by applying arguments to filter (check that in the code) and using a push command or inline by using a cmap command and deleting the current text
- Fix issue when arguments are applied to filter the incfilter is not updated initially.
- Add feature where arguments can be applied to filter command to search and other commands too (possibly even single letter commands like mark-load)

## Emacs
- Rework keybindings for Indentation und Completion
- Show help buffers in same window, if a help window already exists
- Improve Surround code
- Add bindings to evaluate ELips code
- Rework all org-mode keybindings
- Implement flymake handling keybindings
- PDF-View Mode: Add continues scrolling, if possible
- Factor out code for error-lens and jumplist into their own plugins
- Extend error lens support for other things too (Spellchecking)
- Add Grammar checking support

## Other
- Find or create a better opener than mimeopen
- Add a Display Manager
- Networking System Tray
- Add Bluetooth support
- Setup way to duplicate screen
- Find an alternative to fzfp from stpv
- dot script: add code to update all git submodules
- Find a way to fetch new git commits in the background after going into a git repository
- Add code to regularly check for dirty (untracked or not commited) stuff in the dotfiles repo and inform the user
- Maybe switch to btrfs for home partition?
- Update dunst config
- Report xmodmap bug in xinitrc file
- Install a git tui
- Look into git hooks (see also https://pre-commit.com/)
- Look into ways to create widgets window-manager agnostic (e.g. eww)
- Checkout new FZF options
- Find a way to do nightly commits of the dotfiles repo to avoid accidental loss of data.
- Find a better way to handle cleanhome.zsh code (maybe as a systemd user service?)
- Handle environment variables shell agnostic, for example with .env files and PAM\_ENV?
