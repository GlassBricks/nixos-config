{
  config,
  pkgs,
  ...
}: {
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  fonts.fontconfig.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    neofetch

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # misc
    file
    which
    tree
    gnutar

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop # replacement of htop/nmon

    # fonts
    (nerdfonts.override {fonts = ["JetBrainsMono" "DroidSansMono"];})

    # user programs
    discord
    spotify

    kdePackages.merkuro
    jetbrains-toolbox
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "GlassBricks";
    userEmail = "24237065+GlassBricks@users.noreply.github.com";
  };

  programs.fish = {
    enable = true;
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

    # set some aliases, feel free to add more or remove some
    shellAliases = {
    };
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

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
