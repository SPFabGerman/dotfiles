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
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations."fabians-nix-tuxedo" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          {
            networking.hostName = "fabians-nix-tuxedo";
            system.stateVersion = "24.11"; # DO NOT CHANGE
          }
          ./system.nix
          ./localization.nix
          ./x11.nix
          ./programs.nix
          ./auto-upgrade.nix

          ./gaming-nvidia.nix

          ./hardware-configuration.nix
          ./hardware-tuxedo.nix
        ];
      };
    };
}
