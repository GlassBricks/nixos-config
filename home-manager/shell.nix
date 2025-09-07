# shell, terminal, and custom scripts
{pkgs, ...}: let
  aliases = {
    ":wq" = "exit";
    "ls" = "exa --group-directories-first --git --icons";
    "ll" = "exa -l --group-directories-first --git --icons";
    "la" = "exa -la --group-directories-first --git --icons";
  };
in {
  home.sessionPath = [
    "$HOME/bin"
  ];

  home.file = {
    "bin/my-nixos-rebuild" = {
      enable = true;
      source = ../rebuild.py;
    };
  };

  home.packages = with pkgs; [
    comma
  ];

  programs.fish = {
    enable = true;
    shellAliases = aliases;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.local/share/JetBrains/Toolbox/scripts"
    '';
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
    themeFile = "Catppuccin-Macchiato";
    font = {
      name = "JetBrainsMono Nerd Font Light";
      size = 10;
    };
    extraConfig = ''
      include hyde.conf
      background_opacity 0.8
      bold_font JetBrainsMono Nerd Font
      italic_font JetBrainsMono Nerd Font Light Italic
      bold_italic_font JetBrainsMono Nerd Font Italic

      input_delay 0
      repaint_delay 2
      sync_to_monitor no
      wayland_enable_ime no
    '';
  };
}
