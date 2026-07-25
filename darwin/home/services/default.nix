{
  pkgs,
  ...
}:
{
  imports = [
    ./jankyborders.nix
    ./oss-references-pruner.nix
    ./skhd.nix
  ];

  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      defaultCacheTtl = 21600; # 6 hours
      maxCacheTtl = 86400; # 1 day
      pinentry.package = pkgs.pinentry-tty;
    };

    oss-references-pruner = {
      enable = true;
    };
  };
}
