# shell, terminal, and custom scripts
{
  pkgs,
  inputs,
  ...
}: let
  aliases = {
    ":wq" = "exit";
    "ls" = "exa --group-directories-first --git --icons";
    "ll" = "exa -l --group-directories-first --git --icons";
    "la" = "exa -la --group-directories-first --git --icons";
  };
in {
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  home.sessionPath = [
    "$HOME/bin"
  ];

  home.sessionVariables = {
    EDITOR = "zeditor --wait";
  };

  home.file = {
    "bin/my-nixos-rebuild" = {
      enable = true;
      source = ../rebuild.py;
    };
  };

  programs.nix-index-database.comma.enable = true;

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
    keybindings = {
      "shift+enter" = "send_text all \\e\\r";
      "kitty_mod+." = "move_tab_forward";
      "kitty_mod+," = "move_tab_backward";
      "ctrl+shift+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "ctrl+shift+up" = "neighboring_window up";
      "ctrl+shift+down" = "neighboring_window down";
      "ctrl+shift+enter" = "new_window";
      "ctrl+alt+right" = "launch --location=vsplit --cwd=current";
      "ctrl+alt+down" = "launch --location=hsplit --cwd=current";
      "ctrl+alt+shift+left" = "previous_tab";
      "ctrl+alt+shift+right" = "next_tab";
      "ctrl+shift+home" = "move_window_backward";
      "ctrl+shift+end" = "move_window_forward";
      "ctrl+alt+shift+home" = "move_tab_backward";
      "ctrl+alt+shift+end" = "move_tab_forward";
    };
    themeFile = "Catppuccin-Macchiato";
    font = {
      name = "JetBrainsMono Nerd Font Light";
      size = 10;
    };
    extraConfig = ''
      include hyde.conf
      background_opacity 0.7
      bold_font JetBrainsMono Nerd Font
      italic_font JetBrainsMono Nerd Font Light Italic
      bold_italic_font JetBrainsMono Nerd Font Italic

      input_delay 0
      repaint_delay 2
      sync_to_monitor no
      wayland_enable_ime no

      disable_focus_reporting yes
    '';
  };
}
