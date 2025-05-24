{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fabian";
  home.homeDirectory = "/home/fabian";

  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      gitsigns-nvim
      which-key-nvim
      nvim-web-devicons # TODO: Maybe switch to or add mini.icons?
      toggleterm-nvim
      surround-nvim # TODO: Seems to be somewhat out of date, with newer alternatives available.
      nvim-autopairs
      comment-nvim # TODO: Alternatives available
      tmux-nvim
      fzf-lua # TODO: Maybe switch out with telescope.nvim

      # Completion
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lua
    ];
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Basic Xorg Management
    sxhkd playerctl xorg.xmodmap # Hotkeys, Media Control & Key Remapping
    dunst batsignal # Notification daemon & Battery Notifications
    picom # Compositor
    xwallpaper # Wallpaper setter
    dex # Autostarts
    nwg-drawer # Application Launcher
    nwg-bar # Power Menu
    maim # Screenshots
    xclip xsel # Clipboard
    xss-lock i3lock-color # Lockscreen
    arandr srandrd # Multi Monitor Management
    xdragon # Drag-and-Drop of Files

    # Theming
    papirus-icon-theme
    kdePackages.breeze # TODO: It may be useful to change this to something custom, to not be dependent on all that KDE and QT stuff just for some cursors
    pywal # Color generator

    # Terminal emulators
    alacritty
    kitty

    # Shell Customization
    oh-my-posh # Shell Prompt
    zsh-completions
    tmux

    # Basic Applications
    pulsemixer # Volume Manager
    lf # File Management
    emacs-gtk # Editor
    nsxiv # Basic Image Viewer
    btop # System Resource Viewer
    evince # PDF Viewer
    thunderbird # EMails
    syncthing syncthingtray # File Synchronization

    discord
    telegram-desktop
    signal-desktop
    spotify

    # CLI Tools
    fzf # Fuzzy Finder
    bat # Better File Viewer
    ctpv poppler_utils # File Previewer
    eza # Better File Lister
    fd # File Find
    ripgrep
    perl540Packages.FileMimeInfo # mimetype of files
    entr # Running applications on file change
    renameutils
    trash-cli
    unzip
    dust # Storage Usage Visualizer
    stow # Dotfile Management

    # Nix Tools
    nh
    nix-search-tv
    nix-tree

    # Programming Languages & Tools
    python3
    texliveFull
  ];

  nixpkgs.overlays = [
    (final: prev: {
      ueberzug = prev.ueberzugpp;
    })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/fabian/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;



  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
