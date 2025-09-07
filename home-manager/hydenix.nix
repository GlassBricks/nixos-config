{
  inputs,
  # outputs,
  # lib,
  config,
  pkgs,
  ...
}: let
  homeDirectory = config.home.homeDirectory;
  mkOutOfStoreLink = config.lib.file.mkOutOfStoreSymlink;
in {
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

      # extraConfig = ''
      #   decoration {
      #     rounding = 0
      #   }
      #   general {
      #     gaps_in = 0;
      #     gaps_out = 0;
      #   }
      # '';
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
  home.file = let
    homeManagerFilesDir = "${homeDirectory}/nixos-config/home-manager/files";
  in {
    ".config/hypr/keybindings.conf" = {
      source = mkOutOfStoreLink "${homeManagerFilesDir}/hypr/keybindings.conf";
      target = "${homeDirectory}/.config/hypr/keybindings.conf";
    };
    ".config/hypr/userprefs.conf" = {
      source = mkOutOfStoreLink "${homeManagerFilesDir}/hypr/userprefs.conf";
      target = "${homeDirectory}/.config/hypr/userprefs.conf";
    };
  };

  home.packages = with pkgs; [
    nwg-displays
    hyprsunset
  ];
}
