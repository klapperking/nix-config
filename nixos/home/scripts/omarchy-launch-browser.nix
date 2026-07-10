{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "omarchy-launch-browser" ''
      # Thin wrapper matching Omarchy's `omarchy-launch-browser`.
      # Passes --incognito when called with --private.
      set -euo pipefail

      if [[ "''${1:-}" == "--private" ]]; then
        shift
        exec ${pkgs.chromium}/bin/chromium --incognito "$@"
      else
        exec ${pkgs.chromium}/bin/chromium "$@"
      fi
    '')
  ];
}
