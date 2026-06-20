# LibreSplit global-shortcut launcher entries (~/.local/share/applications).
# streamctl binds KDE global shortcuts to these by .desktop id
# (libresplit-<action>.desktop) and toggles them via `streamctl keys/nokeys`,
# so the ids and Name= must stay stable.
{
  config,
  lib,
  pkgs,
  ...
}: let
  ctl = "${pkgs.unstable.libresplit}/bin/libresplit-ctl";
  resetRestart = "${config.home.homeDirectory}/.local/bin/libresplit-reset-restart";

  # action id -> friendly suffix (Name = "LibreSplit <suffix>")
  ctlActions = {
    startorsplit = "Start/Split";
    stoporreset = "Stop/Reset";
    cancel = "Cancel";
    unsplit = "Unsplit";
    skipsplit = "Skip Split";
  };

  mkEntry = friendly: exec: {
    name = "LibreSplit ${friendly}";
    type = "Application";
    inherit exec;
    noDisplay = true;
    startupNotify = false;
  };
in {
  xdg.desktopEntries =
    lib.mapAttrs' (action: friendly:
      lib.nameValuePair "libresplit-${action}" (mkEntry friendly "${ctl} ${action}"))
    ctlActions
    // {
      libresplit-resetrestart = mkEntry "Reset+Restart" resetRestart;
    };
}
