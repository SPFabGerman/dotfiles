# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

# let
#   tuxedo = import (builtins.fetchTarball "https://github.com/sylvesterroos/tuxedo-nixos/archive/master.tar.gz");
# in
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fabians-nix-tuxedo"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable= true;
  services.libinput.touchpad.naturalScrolling = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.awesome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  hardware.graphics.enable = true; # (This should already be enabled by the modules and Steam)
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false; # Use proprietary drivers for now
  # hardware.nvidia.modesetting.enable = true; # May be necessary for some compositors to work properly

  # Setup dediccated GPU and Prime
  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  hardware.nvidia.powerManagement = { # Needs to be here for suspend to work correctly
    enable = true;
    finegrained = true;
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.system-config-printer.enable = true;
  programs.system-config-printer.enable = true;
  services.printing.browsed.enable = true;
  services.avahi = { # Enable Autodiscovery of Printers
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true; # Used by Pipewire to aquire priority

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fabian = {
    isNormalUser = true;
    description = "Fabian Lindner";
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnumake
    wget
    alacritty
    kitty
    sxhkd
    nwg-drawer
    nwg-bar
    lf
    papirus-icon-theme
    thunderbird
    oh-my-posh
    python3
    tmux
    picom
    fzf
    xwallpaper
    pywal
    dunst
    kdePackages.breeze # It may be useful to change this to something custom, to not be dependent on all that KDE and QT stuff just for some cursors
    pulsemixer
    evince
    bat
    batsignal
    btop
    dex
    discord
    dust
    emacs-gtk
    entr
    eza
    fd
    maim
    perl540Packages.FileMimeInfo
    playerctl
    renameutils
    ripgrep
    signal-desktop
    simple-scan
    stow
    syncthing
    syncthingtray
    telegram-desktop
    trash-cli
    udiskie
    unzip
    xclip
    xsel
    xss-lock
    zsh-completions
    nix-zsh-completions
    arandr
    srandrd
    ctpv poppler_utils
    xdragon
    i3lock-color
    nsxiv
    powertop
    texliveFull
    polkit_gnome
    xorg.xmodmap
    spotify
  ];

  nixpkgs.overlays = [
    (final: prev: {
      ueberzug = prev.ueberzugpp;
    })
  ];

  security.polkit.enable = true;

  programs.neovim.enable = true;

  hardware.tuxedo-drivers.enable = true;
  # hardware.tuxedo-rs = { # This thing is basically useless, hard to configure and causes my fans to spin up even while idle
  #   enable = true;
  #   tailor-gui.enable = true;
  # };
  # hardware.tuxedo-control-center.enable = true; # TCC is currently not working, due to outdated Electron Versions (see https://github.com/NixOS/nixpkgs/issues/132206 and https://github.com/tuxedocomputers/tuxedo-control-center/issues/148)
  # hardware.tuxedo-control-center.package = tuxedo-nixos.packages.x86_64-linux.default;

  hardware.sane.brscan5.enable = true;

  hardware.acpilight.enable = true;

  fonts.enableDefaultPackages = false;
  fonts.packages = with pkgs; [
    # Default font packages # TODO: There has to be a better way to do that, if we set enableDefaultPackages to false?
    dejavu_fonts
    gyre-fonts
    liberation_ttf
    unifont
    noto-fonts-color-emoji

    # I overwrite the default gnu-freefont with a otf version, since some programs (emacs) work better with it
    (pkgs.callPackage ./gnu-freefont-otf.nix {})

    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    vistafonts
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.git.enable = true;

  programs.steam.enable = true;
  # programs.steam.gamescopeSession.enable = true; # Can fix resolution problems in some games (e.g. Upscaling)
  programs.gamemode.enable = true;

  environment.sessionVariables = {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
  };

  # Enable Power Management and Power Save features (should already be on by default)
  powerManagement.enable = true;
  services.thermald.enable = true; # Prevents overheating on Intel CPUs
  services.tlp.enable = true; # Auto Tune some settings to save power

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "fabian" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
