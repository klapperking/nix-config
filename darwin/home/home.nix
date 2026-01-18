{
  imports = [
    ./packages.nix
    ./programs
    ./services
  ];

  home = {
    homeDirectory = "/Users/martin";
    username = "martin";
    stateVersion = "25.05";
  };
}
