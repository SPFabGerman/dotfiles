{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  system.autoUpgrade = {
    enable = true;
    # flake = inputs.self.outPath; # This uses the nix-store path of the flake, as it has been copied there. This currently does not work, due to issue https://github.com/NixOS/nix/issues/13367.
    # flake = "path:${inputs.self.outPath}"; # This is a workaround (that works for some reason), but seems to generate a slightly different derivation. Probably because we source the path and not the whole git repository. What exactly is different in the output, I don't know.
    # flake = "path:${./.}";
    flake = "path:/home/fabian/dotfiles/nixos"; # This is a workaround for now. The "path:" here is necessary, to avoid problems with different users (for some reason).
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "tuxedo-nixos"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    # operation = "boot";
    dates = "daily";
    randomizedDelaySec = "15min";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "15min";
    options = "--delete-older-than 30d";
  };

  nix.optimise = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "15min";
  };
}
