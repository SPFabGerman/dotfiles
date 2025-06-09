{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  glib,
  udev,
}:
stdenv.mkDerivation rec {
  pname = "tuxedo-touchpad-toggle";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "tuxedocomputers";
    repo = "tuxedo-touchpad-switch";
    rev = "v${version}";
    hash = "sha256-8kTp6htF810Vmx3MWnqVJ//y2lfGs37Otx5mp8EBmZA=";
  };

  patches = [
    # This removes absolute paths from the installation process.
    # This is needed to build with nix.
    # Be aware, that this breaks the main utility, as the lockfile isn't installed anymore.
    # But I don't care about the main program, so this is fine.
    ./no-absolute-paths.patch

    # This adds the actual toggle utility.
    # The code is taken from https://github.com/jluttine/tuxedo-touchpad-switch/tree/add-touchpad-toggle and rebased to the newest version of the original utility.
    ./add-touchpad-toggle.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    glib
    udev
  ];
}
