# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define user account
  users.users.fabian = {
    isNormalUser = true;
    description = "Fabian Lindner";
    extraGroups = [
      "wheel" # sudo rights
      "video" # backlight and screen control
      "networkmanager" # wifi and network control
      "scanner" # scanner support
      "lp" # also needed for scanning
      "podman" # rootless containers
    ];
  };

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable Power Management and Power Save features (should already be on by default)
  powerManagement.enable = true;
  services.thermald.enable = true; # Prevents overheating on Intel CPUs
  services.tlp.enable = true; # Auto Tune some settings to save power

  # Enable the X11 windowing system.
  # (You can disable this if you're only using the Wayland session.)
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.awesome.enable = true;

  # Apply my patch to awesome to fix some issues with clienticon.lua code
  services.xserver.windowManager.awesome.package = pkgs.awesome.overrideAttrs (
    finalAttrs: previousAttrs: {
      patches = previousAttrs.patches ++ [ ./awesome-clienticon.patch ];
    }
  );

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.naturalScrolling = true;
  services.libinput.touchpad.tappingDragLock = false;

  hardware.acpilight.enable = true;

  # Enable sound with pipewire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true; # Used by Pipewire to aquire priority

  # Enable Lockscreen support
  programs.i3lock.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.system-config-printer.enable = true;
  programs.system-config-printer.enable = true;
  services.printing.browsed.enable = true;
  services.avahi = {
    # Enable Autodiscovery of Printers
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.sane.enable = true;
  hardware.sane.brscan5 = {
    enable = true;
    netDevices.brotherhome = {
      name = "Brother-DCP-J562DW";
      model = "DCP-J562DW";
      nodename = "BRW2C6FC9187896";
    };
  };

  # Manage removable media
  # Automounting is then managed either by a desktop environment or by udiskie
  services.udisks2.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.git.enable = true;

  # Enable containerization to support software for other distributions
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  security.lsm = lib.mkForce [ ]; # Temporary workaround to make old distroboxes work again. See also https://discourse.nixos.org/t/distrobox-selinux-oci-permission-error/64943/15

  programs.firefox.enable = true;

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
      home-manager

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
      tmux

      # Basic Applications
      pulsemixer # Volume Manager
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
      perl540Packages.FileMimeInfo # Mimetype of files
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
      nixfmt-rfc-style
      nh
      nix-search-tv
      nix-tree

      # Programming Languages & Tools
      python3
      texliveFull
      pplatex
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
