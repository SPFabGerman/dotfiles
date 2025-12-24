{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  tuxedo-touchpad-toggle = pkgs.callPackage ./tuxedo-touchpad-toggle/tuxedo-touchpad-toggle.nix { };
in
{
  imports = [ inputs.tuxedo-nixos.nixosModules.default ];
  hardware.tuxedo-drivers.enable = true;
  hardware.tuxedo-control-center.enable = true;
  # hardware.tuxedo-control-center.package = tuxedo-nixos.packages.x86_64-linux.default;

  environment.systemPackages = [ tuxedo-touchpad-toggle ];
  services.udev.packages = [ tuxedo-touchpad-toggle ];

  # services.upower.enable = true;
}
