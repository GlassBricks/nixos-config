{...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "GlassBricks";
      user.email = "24237065+GlassBricks@users.noreply.github.com";
      pull.rebase = true;
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
    };
  };
}
