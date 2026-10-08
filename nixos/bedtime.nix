# Bedtime enforcement: warn at 22:30, suspend at 23:00, and re-suspend every
# 5 minutes until 06:00 if woken. No in-the-moment override by design: to skip
# a night, add its date to `skipNights` (planned ahead) and rebuild.
{
  lib,
  pkgs,
  ...
}: let
  # Evening dates (YYYY-MM-DD) to skip, e.g. a planned event. A night counts
  # until 06:00 the next morning.
  skipNights = [];

  enforce = pkgs.writeShellScript "bedtime-suspend" ''
    night=$(date -d '-6 hours' +%F)
    for skip in ${lib.escapeShellArgs skipNights}; do
      [[ $night == "$skip" ]] && exit 0
    done
    hhmm=$(date +%H%M)
    (( 10#$hhmm >= 2300 || 10#$hhmm < 600 )) || exit 0
    systemctl suspend --check-inhibitors=no
  '';

  # Critical notifications stay on screen in Plasma until dismissed.
  warn = message: "${lib.getExe pkgs.libnotify} --urgency=critical --app-name=Bedtime Bedtime '${message}'";
in {
  systemd.user.services.bedtime-warn = {
    description = "Bedtime warning";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = warn "Suspending at 23:00. Wrap up and start winding down.";
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
      ExecStart = warn "Suspending in 5 minutes. Save your work.";
    };
  };
  systemd.user.timers.bedtime-warn-final = {
    wantedBy = ["timers.target"];
    timerConfig.OnCalendar = "*-*-* 22:55:00";
  };

  systemd.services.bedtime-suspend = {
    description = "Suspend during bedtime hours";
    path = [pkgs.coreutils pkgs.systemd];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = enforce;
    };
  };
  systemd.timers.bedtime-suspend = {
    wantedBy = ["timers.target"];
    timerConfig.OnCalendar = "*-*-* 23,00..05:00/5:00";
  };
}
