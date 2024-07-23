# Misc programs
# If any config becomes large enough it may move to its own file
{pkgs, ...}: {
  imports = [
    ./git.nix
    ./factorio
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.java.enable = true;

  home.packages = with pkgs; [
    neofetch

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

    piper

    # user programs
    gparted

    discord
    spotify

    obsidian

    qmplay2
    kdePackages.dragon
    kdePackages.merkuro

    jetbrains-toolbox
  ];
}
