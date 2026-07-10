{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "omarchy-capture-text-extraction" ''
      # Region-select → grim → tesseract → wl-copy.
      set -euo pipefail

      TMP=$(mktemp --suffix=.png)
      trap 'rm -f "$TMP"' EXIT

      REGION=$(${pkgs.slurp}/bin/slurp) || exit 0
      ${pkgs.grim}/bin/grim -g "$REGION" "$TMP"

      TEXT=$(${pkgs.tesseract}/bin/tesseract "$TMP" - -l eng 2>/dev/null || true)
      TEXT=''${TEXT%$'\n'}  # trim trailing newline

      if [[ -n "$TEXT" ]]; then
        printf '%s' "$TEXT" | ${pkgs.wl-clipboard}/bin/wl-copy
        SNIPPET=$(printf '%s\n' "$TEXT" | head -3)
        ${pkgs.libnotify}/bin/notify-send "OCR text copied" "$SNIPPET"
      else
        ${pkgs.libnotify}/bin/notify-send "OCR failed" "No text detected"
      fi
    '')
  ];
}
