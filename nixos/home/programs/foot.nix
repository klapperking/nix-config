{ ... }:
let
  theme = import ../theme/tokyo-night.nix;
  # Strip leading '#' from hex colors (foot expects `rrggbb`, not `#rrggbb`).
  hex = s: builtins.substring 1 6 s;
in
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "${theme.fonts.monospace}:size=${toString theme.fonts.size}";
        pad = "4x4";
      };
      colors = {
        alpha = "0.97";
        background = hex theme.colors.bg;
        foreground = hex theme.colors.fg;
        regular0 = hex theme.colors.black;
        regular1 = hex theme.colors.red;
        regular2 = hex theme.colors.green;
        regular3 = hex theme.colors.yellow;
        regular4 = hex theme.colors.blue;
        regular5 = hex theme.colors.magenta;
        regular6 = hex theme.colors.cyan;
        regular7 = hex theme.colors.white;
      };
    };
  };
}
