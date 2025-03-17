{
  description = "One flake to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos";
    # tuxedo-nixos.url = "github:sylvesterroos/tuxedo-nixos";
    # tuxedo-nixos.url = "github:chmanie/tuxedo-nixos";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, tuxedo-nixos, home-manager, ... }@inputs: {
    nixosConfigurations."fabians-nix-tuxedo" = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        ./localization.nix

        ./gaming-nvidia.nix
        {
          imports = [ tuxedo-nixos.nixosModules.default ];
          hardware.tuxedo-drivers.enable = true;
          hardware.tuxedo-control-center.enable = true;
          # hardware.tuxedo-control-center.package = tuxedo-nixos.packages.x86_64-linux.default;
          # services.upower.enable = true;
        }
      ];
    };

    homeConfigurations."fabian" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [ ./home.nix ];
    };
  };
}
