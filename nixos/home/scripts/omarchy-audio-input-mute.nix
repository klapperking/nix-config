{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "omarchy-audio-input-mute" ''
      # swayosd-client handles the mute toggle + on-screen indicator.
      set -euo pipefail
      exec ${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle
    '')
  ];
}
