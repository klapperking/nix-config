{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "omarchy-toggle-nightlight" ''
      # Toggle hyprsunset (4000K night light).
      set -euo pipefail

      if ${pkgs.procps}/bin/pgrep -x hyprsunset >/dev/null; then
        ${pkgs.procps}/bin/pkill -x hyprsunset
        ${pkgs.libnotify}/bin/notify-send "Night light off"
      else
        ${pkgs.hyprsunset}/bin/hyprsunset -t 4000 >/dev/null 2>&1 &
        disown
        ${pkgs.libnotify}/bin/notify-send "Night light on"
      fi
    '')
  ];
}
