{ ... }:
{
  programs.mise = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        node = "latest";
      };
    };
  };
}
