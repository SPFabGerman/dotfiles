# Dotfiles TODOs

## General
- Debug higher Fan Usage when charging (Check if same on arch)

## NixOS and HomeManager
- Change Gnome Polkit from Autostart to systemd service (see wiki)
- Install udisksctl
- Move fonts into HomeManager
- Generate /etc/nixos/flake.nix symlink decleratively or document it somewhere
- Garbage Collection (nix.gc)
- Maybe Auto Updates?
- Maybe General Linker (nix-ld)?
- Look for a way to better group entries in the Boot Loader
- Add a Display Manager
- ctpv: Update nix file to include other programs needed for displaying stuff (like pdf files); also check that the current programs really bring the best result
- nvim: add plugins to HomeManager
- Install FoxitReader?
- Add Bluetooth support
- Maybe disable channels entirely?
- Maybe make root dir a tempfs and make nix store it's own partition, so that it is reusable by other operating systems

## ZSH
- Move keybindings into place where function is defined instead of single file. This keeps relevant code together and makes it easier to disable some code.
- Simplify sudo.zsh and make it configurable to use doas, if available
- Go through defined options and clean some up
- Simplify line above prompt to avoid visual issues when resizing
- Check that no aliases are used in init files; define aliases only at end and disable alias expansion for initialization
- Seperate code used by zshrc and zshenv, to avoid double loading
- Make forward slash (and maybe other things too) a word seperator
- Find a better way to handle cleanhome.zsh code
- Look for alternatives to F-Sy-H

- Maybe try out fish?

## Kitty
- Finish setup and add config file
- Move alacritty out of base stow

## LF
- Make previewer reload on file change
- Improve reloading code in generell
- Remove zsh-fifo and implement this in a better, more simplistic way

## AwesomeWM
- Make a nicer status bar
- Remove dependencies on other repos

## Emacs
- Rework keybindings for Indentation und Completion
- Maybe add Ivy-Posframe?
- Show help buffers in same window, if a help window already exists
- Improve Surround code
- Add bindings to evaluate ELips code
- Rework all org-mode keybindings
- Implement flymake handling keybindings
- PDF-View Mode: Add continues scrolling, if possible

## Neovim
- Check out Nix Neovim distributions

## SXHKD
- Fix edit selector
- Add keybinding to open files with mimeopen

## Other
- Install remaining programs from Arch
- Check usage and necessity of bfs
- Look through binaries in ~/bin and ~/scripts and move them to more appropriate locations
- Find an alternative to fzfp from stpv
- Remove stpv code
- Add used git submodules
- Add code to update all git submodules
- Find a way to fetch new git commits in the background after going into a git repository
- Add code to regularly check for dirty (untracked or not commited) stuff in the dotfiles repo and inform the user
- Update dot script to include rebuilds of NixOS and HomeManager; also implement better handling of configuration
- Xinitrc: remove old code
- Maybe switch to btrfs for home partition?
- Move code for terminal color schemes out of build directory
- Remove all things from build directory
