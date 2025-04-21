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
    (inputs.spicetify-nix.lib.mkSpicetify pkgs.unstable {
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        hidePodcasts
        shuffle
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "macchiato";
    })
  ];
}
