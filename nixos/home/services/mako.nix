{ ... }:
let
  theme = import ../theme/tokyo-night.nix;
in
{
  services.mako = {
    enable = true;
    settings = {
      background-color = theme.colors.bg;
      text-color = theme.colors.fg;
      border-color = theme.colors.accent;
      border-radius = 6;
      border-size = 2;
      default-timeout = 5000;
      font = "${theme.fonts.monospace} ${toString theme.fonts.size}";
      anchor = "top-right";
      layer = "overlay";
      margin = "10";
      padding = "10";
      width = 400;
    };
  };
}
