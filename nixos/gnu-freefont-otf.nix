{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "freefont-otf";
  version = "20120503";

  src = fetchzip {
    url = "https://ftp.gnu.org/gnu/freefont/freefont-otf-${version}.tar.gz";
    hash = "sha256-z/lKrPmLcGNzkFqkdZc6fVntfcsoP/QY/spd6zF+OzQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    mv *.otf $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    description = "GNU Free UCS Outline Fonts";
    longDescription = ''
      The GNU Freefont project aims to provide a set of free outline
      (PostScript Type0, TrueType, OpenType...) fonts covering the ISO
      10646/Unicode UCS (Universal Character Set).
    '';
    homepage = "https://www.gnu.org/software/freefont/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
