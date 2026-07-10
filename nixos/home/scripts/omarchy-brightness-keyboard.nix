{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "omarchy-brightness-keyboard" ''
      # Adjust the first available kbd_backlight device.
      set -euo pipefail

      DEVICE=$(${pkgs.brightnessctl}/bin/brightnessctl -l \
        | ${pkgs.gawk}/bin/awk -F"'" '/kbd_backlight/ {print $2; exit}')

      if [[ -z "$DEVICE" ]]; then
        ${pkgs.libnotify}/bin/notify-send "No keyboard backlight found"
        exit 0
      fi

      case "''${1:-}" in
        up)     ${pkgs.brightnessctl}/bin/brightnessctl -d "$DEVICE" set +10% ;;
        down)   ${pkgs.brightnessctl}/bin/brightnessctl -d "$DEVICE" set 10%- ;;
        toggle)
          CURR=$(${pkgs.brightnessctl}/bin/brightnessctl -d "$DEVICE" get)
          MAX=$(${pkgs.brightnessctl}/bin/brightnessctl -d "$DEVICE" max)
          if [[ "$CURR" -gt 0 ]]; then
            ${pkgs.brightnessctl}/bin/brightnessctl -d "$DEVICE" set 0
          else
            ${pkgs.brightnessctl}/bin/brightnessctl -d "$DEVICE" set "$MAX"
          fi
          ;;
        *) echo "Usage: omarchy-brightness-keyboard {up|down|toggle}" >&2; exit 1 ;;
      esac
    '')
  ];
}
