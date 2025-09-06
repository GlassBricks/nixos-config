{
  inputs,
  # outputs,
  # lib,
  # config,
  pkgs,
  ...
}: {
  imports = [
    inputs.hydenix.lib.homeModules
  ];
  nixpkgs.overlays = [
    inputs.hydenix.lib.overlays
  ];

  hydenix.hm = {
    enable = true;
    spotify.enable = false;
    comma.enable = false;
    git.enable = false;
    social.enable = false;
    editors = {
      default = "nvim";
      vim = false;
      neovim = false;
    };
    hyprland = {
      monitors.enable = false;
      keybindings.enable = false;


      extraConfig = ''



      '';
    };

    theme = {
      themes = [
        "Catppuccin Mocha"
        "Decay Green"
        "Tokyo Night"
        "Frosted Glass"
      ];
    };
  };

  home.packages = with pkgs; [
    nwg-displays
  ];
}
