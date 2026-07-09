{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "omarchy-menu" ''
      # Omarchy super-menu — walker-driven meta-menu that fans out to
      # capture / toggle / hardware / system sub-menus.
      #
      # Sibling omarchy-* commands are found via the user's PATH
      # (~/.nix-profile/bin, populated by home.packages).
      set -euo pipefail

      pick() {
        local prompt="$1"
        shift
        printf '%s\n' "$@" | ${pkgs.walker}/bin/walker --dmenu -p "$prompt"
      }

      main_menu() {
        local choice
        choice=$(pick "Omarchy" "Apps" "Capture" "Toggle" "Hardware" "System" "Learn")
        case "$choice" in
          Apps) exec ${pkgs.walker}/bin/walker ;;
          Capture) capture_menu ;;
          Toggle) toggle_menu ;;
          Hardware) hardware_menu ;;
          System) system_menu ;;
          Learn) learn_menu ;;
          *) exit 0 ;;
        esac
      }

      capture_menu() {
        local choice
        choice=$(pick "Capture" "Screenshot" "Screen recording" "Text (OCR)" "Color picker")
        case "$choice" in
          Screenshot) omarchy-capture-screenshot ;;
          "Screen recording") omarchy-capture-screenrecording ;;
          "Text (OCR)") omarchy-capture-text-extraction ;;
          "Color picker") ${pkgs.hyprpicker}/bin/hyprpicker -a ;;
          *) exit 0 ;;
        esac
      }

      toggle_menu() {
        local choice
        choice=$(pick "Toggle" "Idle lock" "Night light" "Waybar" "DND")
        case "$choice" in
          "Idle lock") omarchy-toggle-idle ;;
          "Night light") omarchy-toggle-nightlight ;;
          Waybar) ${pkgs.procps}/bin/pkill -SIGUSR1 waybar || true ;;
          DND)
            if ${pkgs.mako}/bin/makoctl mode | grep -q do-not-disturb; then
              ${pkgs.mako}/bin/makoctl mode -r do-not-disturb
              ${pkgs.libnotify}/bin/notify-send "DND off"
            else
              ${pkgs.mako}/bin/makoctl mode -a do-not-disturb
            fi
            ${pkgs.procps}/bin/pkill -SIGRTMIN+10 waybar || true
            ;;
          *) exit 0 ;;
        esac
      }

      hardware_menu() {
        local choice
        choice=$(pick "Hardware" "WiFi" "Bluetooth" "Audio mixer" "Display info")
        case "$choice" in
          WiFi) ${pkgs.alacritty}/bin/alacritty -e ${pkgs.impala}/bin/impala ;;
          Bluetooth) ${pkgs.alacritty}/bin/alacritty -e ${pkgs.bluetui}/bin/bluetui ;;
          "Audio mixer") ${pkgs.alacritty}/bin/alacritty -e ${pkgs.wiremix}/bin/wiremix ;;
          "Display info")
            ${pkgs.libnotify}/bin/notify-send "Monitors" "$(${pkgs.hyprland}/bin/hyprctl monitors | head -20)"
            ;;
          *) exit 0 ;;
        esac
      }

      system_menu() {
        local choice
        choice=$(pick "System" "Lock" "Suspend" "Reboot" "Shutdown" "Log out")
        case "$choice" in
          Lock) ${pkgs.systemd}/bin/loginctl lock-session ;;
          Suspend) ${pkgs.systemd}/bin/systemctl suspend ;;
          Reboot) ${pkgs.systemd}/bin/systemctl reboot ;;
          Shutdown) ${pkgs.systemd}/bin/systemctl poweroff ;;
          "Log out") ${pkgs.hyprland}/bin/hyprctl dispatch exit ;;
          *) exit 0 ;;
        esac
      }

      learn_menu() {
        # Cheat sheet of the most-used keybinds — served via notify-send since
        # we don't ship the Omarchy keybind chart yet.
        ${pkgs.libnotify}/bin/notify-send -t 15000 "Omarchy keybinds" "$(cat <<'EOF'
      Super+Enter        Terminal
      Super+Space        Walker (apps)
      Super+Alt+Space    This menu
      Super+Escape       System menu
      Super+Ctrl+C       Capture menu
      Super+Ctrl+O       Toggle menu
      Super+Ctrl+H       Hardware menu
      Super+W            Close window
      Super+F            Fullscreen
      Super+1..0         Workspace 1..10
      Print              Screenshot
      Super+Ctrl+L       Lock
      EOF
      )"
      }

      case "''${1:-main}" in
        main) main_menu ;;
        capture) capture_menu ;;
        toggle) toggle_menu ;;
        hardware) hardware_menu ;;
        system) system_menu ;;
        learn) learn_menu ;;
        *) echo "Usage: omarchy-menu [main|capture|toggle|hardware|system|learn]" >&2; exit 1 ;;
      esac
    '')
  ];
}
