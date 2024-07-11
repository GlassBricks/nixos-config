# Misc programs
# If any config becomes large enough it may move to its own file
{pkgs, ...}: {
  imports = [
    ./factorio
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
  programs.java.enable = true;

  home.packages = with pkgs; [
    neofetch

    # utils
    jq # A lightweight and flexible command-line JSON processor
    eza # A modern replacement for ‘ls’
    xsel
    nix-tree
    ripgrep

    alejandra

    # misc
    file
    which
    tree
    gnutar

    btop # replacement of htop/nmon

    # user programs
    gparted

    qmplay2

    discord
    spotify

    kdePackages.merkuro
    kdePackages.dragon

    jetbrains-toolbox
  ];
}
