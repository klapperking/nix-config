{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "omarchy-capture-screenshot" ''
      # Region-select screenshot → edit in satty → wl-copy + save to ~/Pictures/screenshots.
      set -euo pipefail

      DIR="$HOME/Pictures/screenshots"
      mkdir -p "$DIR"
      TS=$(date +%Y%m%d_%H%M%S)
      FILE="$DIR/screenshot-$TS.png"

      REGION=$(${pkgs.slurp}/bin/slurp) || exit 0
      ${pkgs.grim}/bin/grim -g "$REGION" - \
        | ${pkgs.satty}/bin/satty \
            --filename - \
            --output-filename "$FILE" \
            --copy-command "${pkgs.wl-clipboard}/bin/wl-copy" \
            --early-exit \
            --initial-tool crop

      ${pkgs.libnotify}/bin/notify-send "Screenshot saved" "$FILE"
    '')
  ];
}
