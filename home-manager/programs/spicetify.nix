{
  inputs,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  #  imports = [
  #    inputs.spicetify-nix.homeManagerModules.default
  #  ];

  home.packages = [
    (inputs.spicetify-nix.lib.mkSpicetify pkgs {
      wayland = true;
      windowManagerPatch = true;
      enabledExtensions = with spicePkgs.extensions; [
        shuffle
        powerBar
        wikify
        betterGenres
        hidePodcasts
        adblock
        playingSource
        {
          src = pkgs.fetchFromGitHub {
            owner = "BlafKing";
            repo = "spicetify-cat-jam-synced";
            rev = "e7bfd49fcc13457bbc98e696294cf5cf43eb6c31";
            hash = "sha256-pyYa5i/gmf01dkEF9I2awrTGLqkAjV9edJBsThdFRv8=";
          };
          # The actual file name of the extension usually ends with .js
          name = "marketplace/cat-jam.js";
        }
      ];
      enabledCustomApps = with spicePkgs.apps; [
        #        marketplace
        localFiles
        #        ncsVisualizer
        # historyInSidebar
        betterLibrary
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "macchiato";
    })
  ];
}
