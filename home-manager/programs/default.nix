# Misc programs
# If any config becomes large enough it may move to its own file
{pkgs, ...}: {
  imports = [
    ./git.nix
    ./vscode.nix
    ./factorio
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
  ];
}
