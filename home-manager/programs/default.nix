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

  programs.bacon = {
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
    vesktop
    unstable.discord
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
    # clang_19
    # clang_19.out
    # llvm_19
    # mold
    unstable.nodejs
    bun
    pkg-config
    python3Full
    rustup

    gnumake42

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
        installDir = "opt/factorio-11";
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
