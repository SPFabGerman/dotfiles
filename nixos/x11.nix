{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
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
}
