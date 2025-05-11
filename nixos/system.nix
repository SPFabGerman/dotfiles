# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ]; # Include the results of the hardware scan.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fabians-nix-tuxedo"; # Define your hostname.

  # Define user account
  users.users.fabian = {
    isNormalUser = true;
    description = "Fabian Lindner";
    extraGroups = [
      "wheel" # sudo rights
      "video" # backlight and screen control
      "networkmanager" # wifi and network control
      "scanner" "lp" # scanner support
      "podman" # rootless containers
    ];
  };

  environment.sessionVariables = {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
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
  services.xserver.windowManager.awesome.package = pkgs.awesome.overrideAttrs (finalAttrs: previousAttrs: {
    patches = previousAttrs.patches ++ [ ./awesome-clienticon.patch ];
  });

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable= true;
  services.libinput.touchpad.naturalScrolling = true;

  hardware.acpilight.enable = true;

  # Enable sound with pipewire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true; # Used by Pipewire to aquire priority

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

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    gnumake
    wget
    polkit_gnome
    udiskie # Automount utility
    simple-scan # Scan Utility
    distrobox # Easy userspace utility to manage containers
    acpi # Dependency for AwesomeWM-Widgets
    home-manager
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
    (pkgs.callPackage ./gnu-freefont-otf.nix {})

    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    vistafonts
  ];



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
