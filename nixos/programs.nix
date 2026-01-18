{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  # This symlinks the zsh-syntax-highlighting package to /run/current-system/sw/share/zsh-syntax-highlighting/
  environment.pathsToLink = [ "/share/zsh-syntax-highlighting" ];

  programs.git.enable = true;

  programs.firefox.enable = true;

  # Enable containerization to support software for other distributions
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  security.lsm = lib.mkForce [ ]; # Temporary workaround to make old distroboxes work again. See also https://discourse.nixos.org/t/distrobox-selinux-oci-permission-error/64943/15

  # List packages installed in system profile
  environment.systemPackages =
    with pkgs;
    let
      myneovim = wrapNeovimUnstable neovim-unwrapped {
        autoconfigure = true; # Auto configures necessary code for certain plugins
        autowrapRuntimeDeps = true; # Add plugin dependencies to PATH
        wrapRc = false;
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
        ];
      };
    in
    [
      gnumake
      wget
      polkit_gnome
      udiskie # Automount utility
      simple-scan # Scan Utility
      distrobox # Easy userspace utility to manage containers
      acpi # Dependency for AwesomeWM-Widgets

      # Basic Xorg Management
      # Hotkeys, Media Control & Key Remapping
      sxhkd
      playerctl
      xorg.xmodmap

      # Unicode selection
      rofi
      rofimoji

      # Notification daemon & Battery Notifications
      libnotify # for notify-send command
      dunst
      batsignal

      picom # Compositor
      xwallpaper # Wallpaper setter
      dex # Autostarts
      nwg-drawer # Application Launcher
      nwg-bar # Power Menu
      maim # Screenshots
      dragon-drop # Drag-and-Drop of Files

      # Clipboard
      xclip
      xsel

      # Lockscreen
      xss-lock
      i3lock-color

      # Multi Monitor Management
      arandr
      srandrd

      # Theming
      papirus-icon-theme
      kdePackages.breeze # TODO: It may be useful to change this to something custom, to not be dependent on all that KDE and QT stuff just for some cursors
      pywal16 # Color generator
      imagemagick # Runtime dependency of pywal

      # Terminal emulators
      alacritty
      kitty

      # Shell Customization
      oh-my-posh # Shell Prompt
      zsh-completions
      zsh-syntax-highlighting
      tmux

      # Basic Applications
      pulsemixer # Volume Manager
      wiremix
      lf # File Management
      myneovim
      emacs-gtk # Editor
      nsxiv # Basic Image Viewer
      btop # System Resource Viewer
      evince # PDF Viewer
      pdfslicer
      thunderbird # EMails
      onlyoffice-desktopeditors

      # File Synchronization
      syncthing
      syncthingtray

      discord
      signal-desktop
      spotify

      # CLI Tools
      fzf # Fuzzy Finder
      # Better File Viewer, diffs and Previewers
      bat
      difftastic
      (pkgs.callPackage ./ctpv-fork/ctpv-fork.nix { })
      poppler-utils # (needed by ctpv)
      eza # Better File Lister
      fd # File Find
      ripgrep
      perl5Packages.FileMimeInfo # Mimetype of files
      handlr-regex
      entr # Running applications on file change
      renameutils
      trash-cli
      unzip
      dust # Storage Usage Visualizer
      stow # Dotfile Management
      jq # JSON Query
      (pkgs.callPackage ./git-user/git-user.nix { })

      # Nix Tools
      nixfmt
      nh
      nix-search-tv
      nix-tree

      # Programming Languages & Tools
      python3
      go
      gopls
      texliveFull
      (pkgs.callPackage ./pplatex/pplatex.nix { })
      texlab

      (aspellWithDicts (
        dicts: with dicts; [
          en
          de
        ]
      ))
      languagetool
    ];

  nixpkgs.overlays = [
    (final: prev: {
      ueberzug = prev.ueberzugpp;
    })
  ];

  security.polkit.enable = true;

  fonts.enableDefaultPackages = false;
  fonts.packages = with pkgs; [
    # Default font packages # TODO: There has to be a better way to do that, if we set enableDefaultPackages to false?
    dejavu_fonts
    gyre-fonts
    liberation_ttf
    unifont
    noto-fonts-color-emoji

    # I overwrite the default gnu-freefont with a otf version, since some programs (emacs) work better with it
    (pkgs.callPackage ./gnu-freefont/gnu-freefont-otf.nix { })

    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    vista-fonts
  ];
}
