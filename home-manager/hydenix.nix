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
      # configure these manually
      monitors.enable = false;
      keybindings.enable = false;
    };

    theme = {
      active = "Moonlight";
      themes = [
        "Catppuccin Macchiato"
        "Catppuccin Mocha"
        "Cosmic Blue"
        "Decay Green"
        "Eterenal Artic"
        "Ice Age"
        "Moonlight"
        "Nightbrew"
        "Nordic Blue"
        "One Dark"
        "Timeless Dream"
        "Tokyo Night"
        "LimeFrenzy"
        "Breezy Autumn"
        "Rain Dark"
        "Tundra"
        "Synth Wave"
        "Amethyst-Aura"
        "Rose Pine"
        "Green Lush"
        "Material Sakura"
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
    ".local/state/hyde/config" = {
      text = ''
        WEATHER_LOCATION="Austin"
      '';
      mutable = true;
      force = true;
    };
  };

  home.packages = with pkgs; [
    nwg-displays
    hyprsunset
  ];
}
