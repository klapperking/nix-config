{
  imports = [
    ./packages.nix
    ./programs
    ./programs/oxker.nix
    ./services
  ];

  home = {
    homeDirectory = "/Users/martin";
    username = "martin";
    stateVersion = "25.05";
  };
}
