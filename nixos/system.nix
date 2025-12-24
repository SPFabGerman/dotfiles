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

  # Manage removable media
  # Automounting is then managed either by a desktop environment or by udiskie
  services.udisks2.enable = true;

  # Enable Power Management and Power Save features (should already be on by default)
  powerManagement.enable = true;
  services.thermald.enable = true; # Prevents overheating on Intel CPUs
  services.tlp.enable = true; # Auto Tune some settings to save power

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
