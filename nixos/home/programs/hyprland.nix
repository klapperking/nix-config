{ ... }:
let
  theme = import ../theme/tokyo-night.nix;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # Session started by uwsm via SDDM; don't double-manage from HM.
    systemd.enable = false;

    settings = {
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$browser" = "chromium";
      "$fileManager" = "nautilus";
      "$editor" = "alacritty -e nvim";
      "$menu" = "walker";

      monitor = [
        # Fallback auto-detect. Override per-host if you know the outputs.
        ",preferred,auto,1"
      ];

      env = [
        "XCURSOR_SIZE,${toString theme.gtk.cursor_size}"
        "HYPRCURSOR_SIZE,${toString theme.gtk.cursor_size}"
      ];

      input = {
        kb_layout = "us";
        kb_options = "compose:caps";
        follow_mouse = 1;
        repeat_rate = 40;
        repeat_delay = 250;
        numlock_by_default = true;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          scroll_factor = 0.4;
        };
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgb(${theme.colors.active_border})";
        "col.inactive_border" = "rgb(${theme.colors.inactive_border})";
        layout = "dwindle";
        allow_tearing = false;
      };

      decoration = {
        rounding = 8;
        active_opacity = 1.0;
        inactive_opacity = 0.97;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        enabled = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # === Bindings — functional-parity port of Omarchy defaults ===
      # Phase 2b will replace inline commands with omarchy-* wrappers.
      bind = [
        # App launchers
        "$mod, Return, exec, $terminal"
        "$mod ALT, Return, exec, $terminal -e tmux"
        "$mod SHIFT, Return, exec, $browser"
        "$mod SHIFT, B, exec, $browser"
        "$mod SHIFT ALT, B, exec, $browser --incognito"
        "$mod SHIFT, F, exec, $fileManager"
        "$mod SHIFT, N, exec, $editor"
        "$mod SHIFT, M, exec, spotify"
        "$mod SHIFT, G, exec, signal-desktop"
        "$mod SHIFT, O, exec, obsidian"

        # Launcher / menu
        "$mod, SPACE, exec, $menu"
        # TODO Phase 2b:
        #   "$mod ALT, SPACE, exec, omarchy-menu"
        #   "$mod CTRL, E, exec, omarchy-menu emoji"
        #   "$mod CTRL, C, exec, omarchy-menu capture"

        # Window management
        "$mod, W, killactive,"
        "CTRL ALT, DELETE, exec, hyprctl dispatch exit"
        "$mod, F, fullscreen, 0"
        "$mod CTRL, F, fullscreen, 1"
        "$mod, T, togglefloating,"
        "$mod, J, togglesplit,"
        "$mod, P, pseudo,"
        "$mod, O, pin, active"

        # Focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Scratchpad
        "$mod, S, togglespecialworkspace, scratchpad"
        "$mod ALT, S, movetoworkspace, special:scratchpad"

        # Workspace cycling
        "$mod, TAB, workspace, e+1"
        "$mod SHIFT, TAB, workspace, e-1"

        # Move window
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        # Waybar toggle
        "$mod SHIFT, SPACE, exec, pkill -SIGUSR1 waybar"

        # Screenshots — Phase 2a inline; Phase 2b wraps in omarchy-capture-*
        '', Print, exec, grim -g "$(slurp)" - | wl-copy''
        ", ALT_L, Print, exec, gpu-screen-recorder -w screen -o /tmp/rec.mp4"
        "$mod, Print, exec, hyprpicker -a"
        # TODO Phase 2b: OCR via omarchy-capture-text-extraction

        # Lock
        "$mod CTRL, L, exec, hyprlock"

        # Walker clipboard mode
        "$mod CTRL, V, exec, walker -m clipboardmanager"
      ];

      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Media (repeat-on-hold)
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86KbdBrightnessUp, exec, brightnessctl -d '*::kbd_backlight' set +10%"
        ", XF86KbdBrightnessDown, exec, brightnessctl -d '*::kbd_backlight' set 10%-"
      ];

      # Media (fires even when locked)
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Window rules (functional-parity port).
      windowrulev2 = [
        "float, class:^(pavucontrol)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(org.gnome.Calculator)$"
        "suppressevent maximize, class:.*"
        "idleinhibit fullscreen, class:^(chromium)$"
        "idleinhibit fullscreen, class:^(firefox)$"
        # Omarchy default opacity (0.97 focused / 0.9 unfocused)
        "opacity 0.97 0.9, class:.*"
        # Media apps get solid.
        "opacity 1.0 1.0, class:^(mpv)$"
        "opacity 1.0 1.0, class:^(chromium)$"
      ];

      exec-once = [
        "waybar"
        "mako"
        "swaybg -i ${theme.wallpaper} -m fill"
        "hypridle"
        "swayosd-server"
      ];
    };
  };

  # GTK theme applied by home-manager.
  gtk = {
    enable = true;
    theme = {
      name = theme.gtk.theme;
    };
    iconTheme = {
      name = theme.gtk.icon_theme;
    };
    cursorTheme = {
      name = theme.gtk.cursor_theme;
      size = theme.gtk.cursor_size;
    };
  };
}
