{pkgs, ...}: {
  imports = [
    ./git.nix
    # ./vscode.nix
    ./spicetify.nix
    ./custom-factorio.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = false;
  };
  programs.java.enable = true;

  programs.obs-studio.enable = true;

  # programs.freetube = {
  #   package = pkgs.unstable.freetube;
  #   enable = true;
  # };

  programs.bacon = {
    enable = true;
  };

  home.packages = with pkgs; [
    # --- cli / terminal ---
    bubblewrap
    socat
    xsel
    wl-clipboard
    wtype
    wayland-utils
    kwin-mcp
    pdf2md

    killall
    file
    which
    tree
    nix-tree
    lshw

    ripgrep
    ast-grep
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
    hyperfine
    dua
    tokei
    kondo

    alejandra
    nil
    nixd

    zenity
    gh
    ffmpeg

    # --- desktop / gui ---
    piper
    gparted
    qbittorrent-enhanced
    unstable.obsidian
    handbrake

    kdePackages.dragon
    kdePackages.kconfig
    kdePackages.krohnkite
    kdePackages.ktimer
    kdePackages.kcalc
    kdePackages.kalgebra
    haruna
    okteta

    # --- games ---
    chatterino7
    unstable.vesktop
    # unstable.discord

    unstable.libresplit
    prismlauncher

    # --- hardware / peripherals ---
    qmk
    gcc-arm-embedded

    # --- development ---
    nodejs_24
    pnpm
    bun

    python313
    python313Packages.tkinter
    python313Packages.numpy
    uv

    rustup

    pkg-config
    mold
    wild

    graphviz
    ollama-rocm

    unstable.zed-editor
    unstable.jetbrains-toolbox
    unstable.worktrunk
  ];

  # services.syncthing = {
  #   enable = true;
  # };

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
