# Misc programs
# If any config becomes large enough it may move to its own file
{...}: {
  programs.git = {
    enable = true;
    userName = "GlassBricks";
    userEmail = "24237065+GlassBricks@users.noreply.github.com";
    # url.ssh://git@github.com/.insteadOf https://github.com/
    extraConfig = {
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };
}
