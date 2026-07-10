{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "omarchy-brightness-display" ''
      # swayosd-client does both the brightnessctl call and the OSD.
      set -euo pipefail

      case "''${1:-}" in
        up)   exec ${pkgs.swayosd}/bin/swayosd-client --brightness raise ;;
        down) exec ${pkgs.swayosd}/bin/swayosd-client --brightness lower ;;
        *)    echo "Usage: omarchy-brightness-display {up|down}" >&2; exit 1 ;;
      esac
    '')
  ];
}
