# Bedtime enforcement: warn at 22:30, shut down at 23:00, and re-shut down every
# 5 minutes until 06:00 if booted.
# No in-the-moment override by design.
# If really needed, must program the exception manually.
{
  lib,
  pkgs,
  ...
}: let
  enforce = pkgs.writeShellScript "bedtime-shutdown" ''
    hhmm=$(date +%H%M)
    (( 10#$hhmm >= 2300 || 10#$hhmm < 600 )) || exit 0
    systemctl poweroff --check-inhibitors=no
  '';

  # Critical notifications stay on screen in Plasma until dismissed.
  warn = message: "${lib.getExe pkgs.libnotify} --urgency=critical --app-name=Bedtime Bedtime '${message}'";
in {
  systemd.user.services.bedtime-warn = {
    description = "Bedtime warning";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = warn "Shutting down at 23:00. Wrap up and start winding down.";
    };
  };
  systemd.user.timers.bedtime-warn = {
    wantedBy = ["timers.target"];
    timerConfig.OnCalendar = "*-*-* 22:30:00";
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
    timerConfig.OnCalendar = "*-*-* 22:55:00";
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
    timerConfig.OnCalendar = "*-*-* 23,00..05:00/5:00";
  };
}
