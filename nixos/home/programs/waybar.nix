{ ... }:
let
  theme = import ../theme/tokyo-night.nix;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 26;
        spacing = 8;

        modules-left = [
          "custom/omarchy-menu"
          "hyprland/workspaces"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "custom/screen-recording"
          "custom/idle"
          "custom/dnd"
          "network"
          "bluetooth"
          "pulseaudio"
          "cpu"
          "memory"
          "battery"
          "tray"
          "clock"
        ];

        # === Omarchy-specific custom modules ===
        "custom/omarchy-menu" = {
          format = "";
          tooltip = false;
          on-click = "omarchy-menu";
        };

        "custom/screen-recording" = {
          # Written by omarchy-capture-screenrecording. Refreshed on SIGRTMIN+8.
          exec = "test -f \"$HOME/.local/state/omarchy/screen-recording.pid\" && printf '⏺' || printf ''";
          format = "{}";
          signal = 8;
          interval = 30;
          on-click = "omarchy-capture-screenrecording";
        };

        "custom/idle" = {
          # Shows an icon when hypridle is DISABLED (i.e. no idle lock).
          exec = "systemctl --user is-active --quiet hypridle && printf '' || printf '☀'";
          format = "{}";
          signal = 9;
          interval = 30;
          on-click = "omarchy-toggle-idle";
          tooltip-format = "Idle lock toggle";
        };

        "custom/dnd" = {
          # Do-not-disturb indicator, refreshed on SIGRTMIN+10.
          exec = "makoctl mode | grep -q do-not-disturb && printf '🔕' || printf ''";
          format = "{}";
          signal = 10;
          interval = 30;
          on-click = "makoctl mode -t do-not-disturb";
          tooltip-format = "Do not disturb toggle";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
          };
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 60;
        };

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = " {usage}%";
          interval = 5;
        };

        memory = {
          format = " {percentage}%";
          interval = 5;
        };

        battery = {
          format = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          states = {
            good = 90;
            warning = 30;
            critical = 15;
          };
        };

        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-disconnected = "󰤭";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        bluetooth = {
          format = " {status}";
          format-disabled = "󰂲";
          on-click = "bluetui";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "wiremix";
        };

        tray = {
          spacing = 8;
        };
      }
    ];

    style = ''
      * {
        font-family: "${theme.fonts.monospace}";
        font-size: 12px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background: ${theme.colors.bg};
        color: ${theme.colors.fg};
        border-bottom: 2px solid ${theme.colors.bg_light};
      }

      #workspaces button {
        background: transparent;
        color: ${theme.colors.fg_dark};
        padding: 0 8px;
        margin: 0 2px;
        border-radius: 4px;
      }

      #workspaces button.active {
        background: ${theme.colors.accent};
        color: ${theme.colors.bg};
      }

      #workspaces button:hover {
        background: ${theme.colors.bg_light};
        color: ${theme.colors.fg};
      }

      #window {
        color: ${theme.colors.fg_dark};
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #bluetooth,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        color: ${theme.colors.fg};
      }

      #battery.warning {
        color: ${theme.colors.yellow};
      }

      #battery.critical {
        color: ${theme.colors.red};
      }

      #custom-omarchy-menu {
        background: ${theme.colors.accent};
        color: ${theme.colors.bg};
        padding: 0 12px;
        margin: 4px 6px 4px 4px;
        border-radius: 4px;
        font-weight: bold;
      }

      #custom-omarchy-menu:hover {
        background: ${theme.colors.magenta};
      }

      #custom-screen-recording {
        color: ${theme.colors.red};
        padding: 0 8px;
      }

      #custom-idle {
        color: ${theme.colors.yellow};
        padding: 0 8px;
      }

      #custom-dnd {
        color: ${theme.colors.magenta};
        padding: 0 8px;
      }
    '';
  };
}
