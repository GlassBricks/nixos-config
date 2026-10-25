# Bedtime enforcement: warn at `warnTime` (22:30), shut down at `shutdownTime`
# (23:00), and re-shut down every 5 minutes until 06:00 if booted.
{
  lib,
  pkgs,
  ...
}: let
  shutdownTime = {
    hour = 22;
    minute = 45;
  };
  warnTime = {
    hour = 22;
    minute = 15;
  };

  pad = lib.fixedWidthNumber 2;
  fmt = t: "${pad t.hour}:${pad t.minute}";

  # Final warning 5 minutes before shutdown.
  finalWarnTime = let
    t = lib.mod (shutdownTime.hour * 60 + shutdownTime.minute - 5 + 1440) 1440;
  in {
    hour = builtins.div t 60;
    minute = lib.mod t 60;
  };

  shutdownHHMM = shutdownTime.hour * 100 + shutdownTime.minute;
  shutdownHours =
    if shutdownTime.hour == 23
    then "23"
    else "${toString shutdownTime.hour}..23";

  enforce = pkgs.writeShellScript "bedtime-shutdown" ''
    hhmm=$(date +%H%M)
    (( 10#$hhmm >= ${toString shutdownHHMM} || 10#$hhmm < 600 )) || exit 0
    systemctl poweroff --check-inhibitors=no
  '';

  # Critical notifications stay on screen in Plasma until dismissed.
  warn = message: "${lib.getExe pkgs.libnotify} --urgency=critical --app-name=Bedtime Bedtime '${message}'";
in {
  systemd.user.services.bedtime-warn = {
    description = "Bedtime warning";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = warn "Shutting down at ${fmt shutdownTime}. Wrap up and start winding down.";
    };
  };
  systemd.user.timers.bedtime-warn = {
    wantedBy = ["timers.target"];
    timerConfig.OnCalendar = "*-*-* ${fmt warnTime}:00";
  };

  systemd.user.services.bedtime-warn-final = {
    description = "Bedtime final warning";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = warn "Shutting down in 5 minutes. Save your work.";
    };
  };
  systemd.user.timers.bedtime-warn-final = {
    wantedBy = ["timers.target"];
    timerConfig.OnCalendar = "*-*-* ${fmt finalWarnTime}:00";
  };

  systemd.services.bedtime-shutdown = {
    description = "Shut down during bedtime hours";
    path = [pkgs.coreutils pkgs.systemd];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = enforce;
    };
  };
  systemd.timers.bedtime-shutdown = {
    wantedBy = ["timers.target"];
    timerConfig.OnCalendar = "*-*-* ${shutdownHours},00..05:00/5:00";
  };
}
