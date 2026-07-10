{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "omarchy-capture-screenrecording" ''
      # Toggle screen recording via gpu-screen-recorder.
      # State file: $HOME/.local/state/omarchy/screen-recording.pid
      # Waybar recording indicator watches this file (signal: RTMIN+8).
      set -euo pipefail

      DIR="$HOME/Videos"
      STATE_DIR="$HOME/.local/state/omarchy"
      mkdir -p "$DIR" "$STATE_DIR"
      PID_FILE="$STATE_DIR/screen-recording.pid"

      if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        # Currently recording — stop.
        PID=$(cat "$PID_FILE")
        # gpu-screen-recorder finalizes on SIGINT
        kill -INT "$PID"
        rm -f "$PID_FILE"
        ${pkgs.libnotify}/bin/notify-send "Recording stopped"
      else
        # Not recording — start.
        rm -f "$PID_FILE"
        TS=$(date +%Y%m%d_%H%M%S)
        FILE="$DIR/recording-$TS.mp4"
        ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder \
          -w screen \
          -c mp4 \
          -f 60 \
          -a "default_output" \
          -o "$FILE" &
        echo $! > "$PID_FILE"
        ${pkgs.libnotify}/bin/notify-send "Recording started" "$FILE"
      fi

      # Signal Waybar to refresh the recording indicator.
      ${pkgs.procps}/bin/pkill -SIGRTMIN+8 waybar || true
    '')
  ];
}
