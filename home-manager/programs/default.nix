# Misc programs
# If any config becomes large enough it may move to its own file
{pkgs, ...}: {
  imports = [
    ./git.nix
    ./vscode.nix
    ./custom-factorio.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.java.enable = true;

  programs.obs-studio.enable = true;

  programs.freetube = {
    package = pkgs.unstable.freetube;
    enable = true;
  };

  home.packages = with pkgs; [
    # dev
    unstable.nodejs
    pnpm
    yarn
    bun

    # utils
    jq # A lightweight and flexible command-line JSON processor
    eza # A modern replacement for ‘ls’
    xsel
    nix-tree
    ripgrep
    killall
    file
    which
    tree
    gnutar

    # misc

    btop
    zenity

    # user programs
    # utils
    piper
    gparted
    alejandra
    ffmpeg

    unstable.zed-editor

    # qmk
    qmk
    gcc-arm-embedded

    # games and stuff
    urn-timer

    steam
    discord
    vesktop

    # other applications
    tribler
    spotify
    spicetify-cli
    obsidian

    # video players, kde stuff
    kdePackages.dragon
    kdePackages.merkuro
    kdePackages.ktimer
    kdePackages.kcalc
    kdePackages.kalgebra
    okteta

    handbrake

    # dev
    graphviz
    jetbrains-toolbox
    (win2xcur.overrideAttrs {
      src = fetchFromGitHub {
        owner = "quantum5";
        repo = "win2xcur";
        rev = "8e71037f5f90f3cea82a74fe516ee637dea113fa";
        sha256 = "sha256-4Evd3Aa2gpS2J+vkflV/aQypX419l8gI3Pa39wF9D0U=";
      };
    })
  ];

  custom.factorio-install = {
    instances = {
      default = {
        displayName = "";
        executableName = "factorio";
      };
      planning = {};
      "stable" = {
        installDir = "opt/factorio-stable";
      };
      "2.0.33" = {
        installDir = "opt/factorio-2.0.33";
        links = {
          "saves" = ".factorio/instances/default/saves";
        };
      };
      "1.1" = {
        displayName = "1.1";
        executableName = "factorio11";
        installDir = "opt/factorio-1.1";
        linkCommon = [];
      };
      "1.1-100p-design" = {
        displayName = "1.1 100% Design";
        installDir = "opt/factorio-1.1";
        linkCommon = [];
      };
      "1.1-100p-runs" = {
        displayName = "1.1 100% Runs";
        installDir = "opt/factorio-1.1";
        linkCommon = [];
      };
    };
  };
}
