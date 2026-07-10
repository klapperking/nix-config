{
  ...
}:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "TokyoNight";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 11;
      font-feature = [
        "-liga"
        "-calt"
        "-dlig"
      ];
      # macOS-only setting, silently ignored on Linux
      macos-titlebar-style = "hidden";
      window-padding-x = 4;
      window-padding-y = 4;
    };
  };
}
