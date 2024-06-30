# Misc programs
# If any config becomes large enough it may move to its own file
{...}: {
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
}
