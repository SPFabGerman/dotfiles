{
  description = "One flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos";
    # tuxedo-nixos.url = "github:sylvesterroos/tuxedo-nixos";
    # tuxedo-nixos.url = "github:chmanie/tuxedo-nixos";
  };

  outputs =
    { nixpkgs, tuxedo-nixos, ... }@inputs:
    {
      nixosConfigurations."fabians-nix-tuxedo" = nixpkgs.lib.nixosSystem {
        modules = [
          ./system.nix
          ./localization.nix

          ./gaming-nvidia.nix

          # Module for all Tuxedo code. TODO: Extract into it's own file.
          (
            let
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              tuxedo-touchpad-toggle = pkgs.callPackage ./tuxedo-touchpad-toggle/tuxedo-touchpad-toggle.nix { };
            in
            {
              imports = [ tuxedo-nixos.nixosModules.default ];
              hardware.tuxedo-drivers.enable = true;
              hardware.tuxedo-control-center.enable = true;
              # hardware.tuxedo-control-center.package = tuxedo-nixos.packages.x86_64-linux.default;
              environment.systemPackages = [ tuxedo-touchpad-toggle ];
              services.udev.packages = [ tuxedo-touchpad-toggle ];
              # services.upower.enable = true;
            }
          )
        ];
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
