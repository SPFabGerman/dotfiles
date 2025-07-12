# Dotfiles TODOs

## General
- Debug higher Fan Usage when charging (Check if same on arch)

## NixOS and HomeManager
- Change Gnome Polkit from Autostart to systemd service (see wiki)
- Move fonts into HomeManager
- Maybe Auto Updates? (https://wiki.nixos.org/wiki/Automatic_system_upgrades)
- Automatic Garbage Collection (nix.gc) and Expiration of old generations
- Automatic Store Optimization
- Maybe General Linker (nix-ld)?
- ctpv: Update nix file to include other programs needed for displaying stuff (like pdf files); also check that the current programs really bring the best result
- Maybe disable channels entirely?
- make nix store it's own partition, so that it is reusable by other operating systems
- make formatting automatic

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

## Kitty
- Finish setup and add config file
- Move alacritty out of base stow

## LF
- Make previewer reload on file change
- Improve reloading code in generell
- Remove zsh-fifo and implement this in a better, more simplistic way
- Remove bookmarks and use internals marks instead
- Free up hjkl keys for movement
- Add a way to toggle numbers for faster jumps

## AwesomeWM
- Make a nicer status bar
- Look into ways to handle common widgets outside of Awesome (e.g. eww)

## Emacs
- Rework keybindings for Indentation und Completion
- Maybe add Ivy-Posframe?
- Show help buffers in same window, if a help window already exists
- Improve Surround code
- Add bindings to evaluate ELips code
- Rework all org-mode keybindings
- Implement flymake handling keybindings
- PDF-View Mode: Add continues scrolling, if possible
- Factor out code for error-lens and jumplist into their own plugins
- Extend error lens support for other things too (Spellchecking)
- Add Grammar checking via LanguageTool for org-mode

## Neovim
- Check out Nix Neovim distributions
- Cleanup config
- Update plugins to modern standards (surround, comments, completion, ...; see home.nix)
- (WhichKey + Gitsigns: use correct icons)
- WhichKey: Move descriptions to key definitions

- Maybe look into evil-helix?

## Other
- Install remaining programs from Arch
- Find or create a better opener than mimeopen
- Add a Display Manager
- Networking System Tray
- Add Bluetooth support
- Setup way to duplicate screen
- Look through binaries in ~/bin and ~/scripts and move them to more appropriate locations
- Find an alternative to fzfp from stpv
- Remove stpv code
- dot script: add code to update all git submodules
- Find a way to fetch new git commits in the background after going into a git repository
- Add code to regularly check for dirty (untracked or not commited) stuff in the dotfiles repo and inform the user
- Maybe switch to btrfs for home partition?
- Update dunst config
- Report xmodmap bug in xinitrc file
- Create Pull Request for changes in Awesome
- Install a git tui
- Look into git hooks (see also https://pre-commit.com/)
- Add LSP Servers

## Wayland Blocks
- Good window manager
- Hotkeys
- Ueberzug terminal images
- Screenshots
