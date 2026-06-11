{
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;
    settings = {
      theme = "TokyoNight";
      font-family = "MesloLGS NF";
      font-size = 11;
      macos-titlebar-style = "hidden";
      window-padding-x = 4;
      window-padding-y = 4;
    };
  };
}