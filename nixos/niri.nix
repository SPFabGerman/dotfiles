{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.niri.enable = true;
  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
  security.pam.services.swaylock = { };

  environment.systemPackages = with pkgs; [
    waybar
    wlr-which-key
    # mako
    swaybg
    swaylock
    swayidle
    swaynotificationcenter
    xwayland-satellite
    brightnessctl
    wl-mirror
    polkit_gnome
    udiskie # Automount utility
    playerctl # Media control
    libnotify # for notify-send command
    batsignal
    nwg-drawer # Application Launcher
    nwg-bar # Power Menu
  ];

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    # We don't want to start it by default for every graphical environment, only selected ones.
    # wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
