{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [
    "modesetting"
    "fbdev"
    "nvidia"
  ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true; # Highly recommended for some compositors to work properly. (Seems to already be enabled by default.)

  # Setup dediccated GPU and Prime Offloading
  # NOTE: The bus id's may be different per hardware!
  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
  };

  hardware.nvidia.powerManagement = {
    enable = true;
    finegrained = true;
  };
}
