{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  file,
  openssl,
  atool,
  ouch,
  bat,
  chafa,
  delta,
  ffmpeg,
  ffmpegthumbnailer,
  fontforge,
  glow,
  imagemagick,
  jq,
  poppler-utils,
  ueberzug,
}:

stdenv.mkDerivation rec {
  pname = "ctpv";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "cafreo";
    repo = "ctpv";
    rev = "v${version}";
    hash = "sha256-9Hh6FI64u+Ank8NfCIaMUpNfcp4jrGFACP4CqB+upo0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    file # libmagic
    openssl # libcrypto
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preFixup = ''
    wrapProgram $out/bin/ctpv \
      --prefix PATH ":" "${
        lib.makeBinPath [
          # atool # for archive files
          ouch # for archive files
          bat
          chafa # for image files on Wayland
          delta # for diff files
          ffmpeg
          ffmpegthumbnailer
          fontforge
          glow # for markdown files
          imagemagick
          jq # for json files
          poppler-utils # for pdf files
          ueberzug # for image files on X11
        ]
      }";
  '';

  patches = [
    # This fixes a bug when autochafa is on. But for some reason it still won't work. (Maybe because of the sed command after?)
    # Best to just stick to kitty without tmux for now.
    ./ctpv-fixes.diff
  ];

  meta = {
    description = "File previewer for a terminal";
    homepage = "https://github.com/cafreo/ctpv";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.wesleyjrz ];
  };
}
