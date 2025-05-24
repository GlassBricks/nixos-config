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

  programs.fish = {
    enable = true;
    shellAliases = aliases;
  };
  programs.nushell = {
    enable = true;
    # for editing directly to config.nu
    extraConfig = ''
      let carapace_completer = {|spans|
      carapace $spans.0 nushell ...$spans | from json
      }
      $env.config = {
       show_banner: false,
       completions: {
       case_sensitive: false # case-sensitive completions
       quick: true    # set to false to prevent auto-selecting completions
       partial: true    # set to false to prevent partial filling of the prompt
       algorithm: "fuzzy"    # prefix or fuzzy
       external: {
       # set to false to prevent nushell looking into $env.PATH to find more suggestions
           enable: true
       # set to lower can improve completion performance at the cost of omitting some options
           max_results: 100
           completer: $carapace_completer # check 'carapace_completer'
         }
       }
      }
      $env.PATH = ($env.PATH |
      split row (char esep) |
      prepend /home/myuser/.apps |
      append /usr/bin/env
      )
    '';
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

  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
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
      background_opacity 0.8
      bold_font JetBrainsMono Nerd Font
      italic_font JetBrainsMono Nerd Font Light Italic
      bold_italic_font JetBrainsMono Nerd Font Italic
    '';
  };
}
