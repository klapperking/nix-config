{ ... }:
{
  imports = [
    ./packages.nix
    ./programs
    ./services
    ../../shared/home/programs
    ../../shared/home/services
  ];

  home = {
    homeDirectory = "/home/martin";
    username = "martin";
    stateVersion = "25.11";
  };
}
