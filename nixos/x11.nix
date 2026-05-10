{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
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

  environment.systemPackages = with pkgs; [
    picom # Compositor
    xwallpaper # Wallpaper setter
    maim # Screenshots
    dragon-drop # Drag-and-Drop of Files

    sxhkd # Hotkeys
    xmodmap # Key Remapping
    playerctl # Media control

    nwg-drawer # Application Launcher
    nwg-bar # Power Menu

    dex # Autostarts
    polkit_gnome
    udiskie # Automount utility

    # Notifications
    dunst
    libnotify # for notify-send command
    batsignal

    # Clipboard
    xclip
    xsel

    # Lockscreen
    xss-lock
    i3lock-color

    # Multi Monitor Management
    arandr
    srandrd

    acpi # Dependency for AwesomeWM-Widgets
  ];
}
