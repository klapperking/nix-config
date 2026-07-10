{ ... }:
let
  theme = import ../theme/tokyo-night.nix;
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 4;
          y = 4;
        };
        decorations = "none";
        opacity = 0.97;
      };
      font = {
        normal = {
          family = theme.fonts.monospace;
          style = "Regular";
        };
        size = theme.fonts.size;
      };
      colors = {
        primary = {
          background = theme.colors.bg;
          foreground = theme.colors.fg;
        };
        normal = {
          black = theme.colors.black;
          red = theme.colors.red;
          green = theme.colors.green;
          yellow = theme.colors.yellow;
          blue = theme.colors.blue;
          magenta = theme.colors.magenta;
          cyan = theme.colors.cyan;
          white = theme.colors.white;
        };
        bright = {
          black = theme.colors.black;
          red = theme.colors.red;
          green = theme.colors.green;
          yellow = theme.colors.yellow;
          blue = theme.colors.blue;
          magenta = theme.colors.magenta;
          cyan = theme.colors.cyan;
          white = theme.colors.white;
        };
      };
    };
  };
}
