{
  description = "One flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs2311.url = "github:nixos/nixpkgs/nixos-23.11";
    tuxedo-nixos = {
      url = "github:sylvesterroos/tuxedo-nixos";
      # url = "github:chmanie/tuxedo-nixos";
      # inputs.nixpkgs.follows = "nixpkgs2311";
    };
  };

  outputs = { nixpkgs, tuxedo-nixos, ... }@inputs: {

    nixosConfigurations."fabians-nix-tuxedo" = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        tuxedo-nixos.nixosModules.default
        {
          hardware.tuxedo-control-center.enable = true;
          hardware.tuxedo-control-center.package = tuxedo-nixos.packages.x86_64-linux.default;
          # services.upower.enable = true;
        }
      ];
    };
  };
}
