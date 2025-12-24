# Dotfiles TODOs

- Add a Readme

## NixOS and HomeManager
- Change Gnome Polkit from Autostart to systemd service (see wiki)
- Maybe disable channels entirely?
- make nix store it's own partition, so that it is reusable by other operating systems
- add pplatex symlinks

## ZSH
- Go through defined options and clean some up
- Simplify line above prompt to avoid visual issues when resizing
- Check that no aliases are used in init files; define aliases only at end and disable alias expansion for initialization
- Seperate code used by zshrc and zshenv, to avoid double loading
- Make forward slash (and maybe other things too) a word seperator
- Find a better way to handle cleanhome.zsh code
- Look for alternatives to F-Sy-H
- Try out zoxide

- Maybe try out fish?

## LF
- Make previewer reload on file change
- Remove zsh-fifo and implement this in a better, more simplistic way
- Free up hjkl keys for movement
- Add a way to toggle numbers for faster jumps

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

## Neovim
- Cleanup config
- Update plugins to modern standards (surround, comments, completion, ...; see home.nix; maybe use mini.nvim?)

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
- Look into ways to handle common widgets outside of Awesome (e.g. eww)
- Try out Wayland + Cosmic Desktop
