{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "ben";
    homeDirectory = "/home/ben";
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Light" ];
    };
  };

  home.packages = with pkgs; [
    neofetch

    # utils
    jq # A lightweight and flexible command-line JSON processor
    eza # A modern replacement for ‘ls’
    xsel

    alejandra

    # misc
    file
    which
    tree
    gnutar

    btop # replacement of htop/nmon

    # fonts
    (nerdfonts.override {fonts = ["JetBrainsMono" "DroidSansMono"];})

    # util programs
    gparted

    # user programs
    discord
    spotify

    kdePackages.merkuro

    jetbrains-toolbox
  ];

  programs.git = {
    enable = true;
    userName = "GlassBricks";
    userEmail = "24237065+GlassBricks@users.noreply.github.com";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ":wq" = "exit";
    };
  };
  home.sessionPath = [
    "$HOME/bin"
  ];

  home.file = {
    "bin/my-nixos-update" = {
      enable = true;
      source = ../rebuild.sh;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
    theme = "Catppuccin-Macchiato";
    font = {
      name = "JetBrainsMono Nerd Font Light";
      size = 10;
    };
    extraConfig = ''
      background_opacity 0.8
      bold_font JetBrainsMono Nerd Font
      italic_font JetBrainsMono Nerd Font Light Italic
      bold_italic_font JetBrainsMono Nerd Font Italic
    '';
  };

  programs.java.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
