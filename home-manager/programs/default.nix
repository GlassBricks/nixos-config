{pkgs, ...}: {
  imports = [
    ./git.nix
    ./vscode.nix
    ./spicetify.nix
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
    # utils and cli programs
    uutils-coreutils-noprefix
    xsel
    killall
    file
    which
    tree
    nix-tree
    ripgrep
    bat
    eza
    fd
    fselect

    jq
    gnutar
    unzip

    btop
    gitui
    delta
    zenity
    yazi
    hyperfine
    dua
    tokei
    just
    mask
    masklint
    mprocs
    kondo

    ffmpeg
    alejandra

    nil
    nixd
    nix-index

    # Misc GUI programs
    piper
    gparted
    qbittorrent-enhanced
    unstable.obsidian

    # qmk
    qmk
    gcc-arm-embedded

    # games and stuff
    urn-timer

    steam
    unstable.vesktop
    prismlauncher

    # video players,and media stuff
    kdePackages.dragon
    okteta
    haruna
    kdePackages.ktimer
    kdePackages.kcalc
    kdePackages.kalgebra
    handbrake

    kdePackages.kio-gdrive

    # dev
    gcc
    unstable.nodejs
    bun
    python3

    graphviz
    ollama-rocm

    # editors
    unstable.neovide
    unstable.zed-editor
    unstable.jetbrains-toolbox
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
        executableName = "factorio-stable";
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
