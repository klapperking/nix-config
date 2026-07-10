{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "omarchy-audio-output-switch" ''
      # List PipeWire sinks and let the user pick via walker --dmenu.
      set -euo pipefail

      # Get sink IDs + names. Format from `wpctl status`:
      #   │  ├─ 47. Built-in Audio Analog Stereo [vol: 0.65]
      mapfile -t SINKS < <(${pkgs.pipewire}/bin/wpctl status \
        | ${pkgs.gnused}/bin/sed -n '/^ ├─ Sinks:/,/^ ├─ Sources:/p' \
        | ${pkgs.gnugrep}/bin/grep -oE '│  ├─ [0-9]+\. .*' \
        | ${pkgs.gnused}/bin/sed 's/│  ├─ //; s/ \[vol:.*//')

      if [[ ''${#SINKS[@]} -eq 0 ]]; then
        ${pkgs.libnotify}/bin/notify-send "No audio sinks found"
        exit 1
      fi

      CHOICE=$(printf '%s\n' "''${SINKS[@]}" \
        | ${pkgs.walker}/bin/walker --dmenu -p "Audio output") || exit 0
      [[ -z "$CHOICE" ]] && exit 0

      SINK_ID=$(printf '%s' "$CHOICE" | ${pkgs.gawk}/bin/awk -F. '{print $1}')
      ${pkgs.pipewire}/bin/wpctl set-default "$SINK_ID"
      ${pkgs.libnotify}/bin/notify-send "Audio output" "$CHOICE"
    '')
  ];
}
