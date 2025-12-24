{ config, pkgs, ... }:
{
  systemd.user.services."failure-notification@" = {
    Unit.Description = "Send a notification about a failed systemd unit";
    Service = {
      Type = "oneshot";
      # TODO: Should this be hard linked with pkgs against the notify-send binary itself?
      ExecStart = ''/usr/bin/env notify-send -u critical "Service %i failed" "See logs for more information."'';
    };
  };

  systemd.user.services.home-manager-update = {
    Unit = {
      Description = "Update of HomeManager";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
      OnFailure = "failure-notification@%n.service";
    };

    Service = {
      Type = "oneshot";
      ExecStart = ''/home/fabian/scripts/dot hm-bg'';
    };
  };

  systemd.user.timers.home-manager-update = {
    Unit.Description = "Daily Update of HomeManager";
    Install.WantedBy = [ "timers.target" ];

    Timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };
  };
}
