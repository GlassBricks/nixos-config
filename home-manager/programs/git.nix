{...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "GlassBricks";
      user.email = "24237065+GlassBricks@users.noreply.github.com";
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
