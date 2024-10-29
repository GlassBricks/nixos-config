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

  programs.freetube.enable = true;

  home.packages = with pkgs; [
    # dev
    nodejs
    bun

    # utils
    jq # A lightweight and flexible command-line JSON processor
    eza # A modern replacement for ‘ls’
    xsel
    nix-tree
    ripgrep

    killall
    xorg.xkill

    alejandra

    # misc
    file
    which
    tree
    gnutar

    btop # replacement of htop/nmon

    # user programs
    piper
    gparted

    livesplit-one

    discord
    vesktop
    spotify

    obsidian

    qmplay2
    kdePackages.dragon
    kdePackages.merkuro
    kdePackages.ktimer
    kdePackages.kcalc
    kdePackages.kalgebra

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
    default = {
      displayName = "";
      executableName = "factorio";
    };
    "100p-design" = {
      displayName = "100% Design";
    };
    "100p-runs" = {
      displayName = "100% Runs";
      linkCommon = ["mods"];
    };
    "space-age" = {
      displayName = "Spage age";
      linkCommon = [];
      installDir = "opt/factorio-spage-age";
    };
  };
}
