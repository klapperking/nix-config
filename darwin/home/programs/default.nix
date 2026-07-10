{
  pkgs,
  ...
}:
{
  imports = [
    ../../../shared/home/programs
  ];

  programs = {
    chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };

    # Ghostty upstream fails to build cleanly on Darwin from source;
    # use the prebuilt binary. Linux uses the shared/ default package.
    ghostty.package = pkgs.ghostty-bin;
  };
}
