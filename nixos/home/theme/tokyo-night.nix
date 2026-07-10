# Tokyo Night palette (from Omarchy themes/tokyo-night/colors.toml).
# Consumed by Hyprland, Waybar, Walker, Mako, Alacritty, Foot, Hyprlock.
{
  name = "tokyo-night";

  colors = {
    bg = "#1a1b26";
    bg_dark = "#16161e";
    bg_light = "#292e42";
    bg_highlight = "#292e42";
    fg = "#c0caf5";
    fg_dark = "#a9b1d6";
    fg_gutter = "#3b4261";
    accent = "#7aa2f7";
    red = "#f7768e";
    green = "#9ece6a";
    yellow = "#e0af68";
    blue = "#7aa2f7";
    magenta = "#bb9af7";
    cyan = "#7dcfff";
    black = "#414868";
    white = "#c0caf5";
    orange = "#ff9e64";

    # Border colors without leading # for Hyprland's `rgb(...)` syntax.
    active_border = "7aa2f7";
    inactive_border = "565f89";
  };

  fonts = {
    monospace = "JetBrainsMono Nerd Font";
    size = 11;
  };

  gtk = {
    theme = "Adwaita-dark";
    icon_theme = "Yaru-magenta";
    cursor_theme = "Yaru";
    cursor_size = 24;
  };

  # Wallpaper: placeholder path. Drop a JPG here on the target machine, or
  # override via services.swaybg / Hyprland exec-once.
  wallpaper = "/etc/nixos/wallpapers/tokyo-night.jpg";
}
