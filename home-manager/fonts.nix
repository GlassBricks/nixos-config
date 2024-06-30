{pkgs, ...}: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font Light"];
    };
  };
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono" "DroidSansMono"];})
  ];
}
