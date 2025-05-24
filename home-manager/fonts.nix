{pkgs, ...}: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font Light"];
    };
  };
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.droid-sans-mono
  ];
}
