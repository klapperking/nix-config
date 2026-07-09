{ ... }:
let
  theme = import ../theme/tokyo-night.nix;
  hex = s: builtins.substring 1 6 s;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = [
        {
          path = theme.wallpaper;
          blur_passes = 3;
          blur_size = 6;
        }
      ];

      input-field = [
        {
          size = "300, 60";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          outer_color = "rgb(${theme.colors.active_border})";
          inner_color = "rgb(${theme.colors.inactive_border})";
          font_color = "rgb(${hex theme.colors.fg})";
          fade_on_empty = true;
          placeholder_text = "<i>Password...</i>";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          text = "$TIME";
          color = "rgb(${hex theme.colors.fg})";
          font_size = 96;
          font_family = theme.fonts.monospace;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
