{
  stdenv,
  lib,
  fetchurl,
  makeDesktopItem,
  wrapGAppsHook,
  glib,
  webkitgtk,
  imagemagick,
  autoPatchelfHook,
}: let
  pname = "livesplit-one";
  icon = fetchurl {
    url = "https://raw.githubusercontent.com/LiveSplit/LiveSplitOne/c39dbe175157145da4d59bfa9b5a8c1f444667d9/src/assets/icon.svg";
    hash = "sha256-mGx4tUUyJKFUJhs9sgS5/0PaK9/LS0mQ2jFyREcEymc=";
  };
  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${pname} %U";
    icon = pname;
    desktopName = "Livesplit One";
    comment = "Livesplit one for desktop, my quick and dirty nixos patch";
    categories = ["Game"];
  };
in
  stdenv.mkDerivation {
    pname = pname;
    version = "0.1.0";

    src = fetchurl {
      url = "https://github.com/LiveSplit/LiveSplitOne/releases/download/latest/LiveSplitOne-x86_64-linux.tar.gz";
      hash = "sha256-jM5/HQsSctfq1yIyzcLFFlfJ3WdUgkzCfnjkC+fKgKI=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      imagemagick
      wrapGAppsHook
    ];

    buildInputs = [
      glib
      webkitgtk
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -m755 -D ${pname} $out/bin/${pname}

      for i in 16 24 48 64 96 128 256 512; do
        mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
        magick ${icon} -background none -resize ''${i}x''${i} $out/share/icons/hicolor/''${i}x''${i}/apps/${pname}.png
      done
      ln -s ${desktopItem}/share/applications $out/share

      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://github.com/LiveSplit/LiveSplitOne";
      description = "LiveSplit One";
      license = licenses.mit;
      platforms = platforms.linux;
      mainProgram = pname;
    };
  }
