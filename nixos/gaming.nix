{ config, pkgs, ... }:
{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true; # Can fix resolution problems in some games (e.g. Upscaling)
  programs.gamemode.enable = true;

  hardware.graphics.enable = true; # (This should already be enabled by Steam)
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = with pkgs; [
    # Celeste (via Steam)
    (olympus.override { celesteWrapper = "steam-run"; })
  ];
}
