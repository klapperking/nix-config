{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "omarchy-toggle-idle" ''
      # Toggle the user's hypridle systemd unit.
      # Waybar idle indicator is refreshed via SIGRTMIN+9.
      set -euo pipefail

      if ${pkgs.systemd}/bin/systemctl --user is-active --quiet hypridle; then
        ${pkgs.systemd}/bin/systemctl --user stop hypridle
        ${pkgs.libnotify}/bin/notify-send "Idle lock disabled"
      else
        ${pkgs.systemd}/bin/systemctl --user start hypridle
        ${pkgs.libnotify}/bin/notify-send "Idle lock enabled"
      fi

      ${pkgs.procps}/bin/pkill -SIGRTMIN+9 waybar || true
    '')
  ];
}
