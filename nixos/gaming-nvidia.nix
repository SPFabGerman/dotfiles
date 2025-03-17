{ config, pkgs, ... }:
{
  programs.steam.enable = true;
  # programs.steam.gamescopeSession.enable = true; # Can fix resolution problems in some games (e.g. Upscaling)
  programs.gamemode.enable = true;

  hardware.graphics.enable = true; # (This should already be enabled by Steam)
  hardware.graphics.enable32Bit = true;

  # Setup Nvidia graphics card
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
}
