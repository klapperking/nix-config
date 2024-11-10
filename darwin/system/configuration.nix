{ pkgs, ... }:

# TODO: All system settings - hide dock etc.

# TODO: Setup sops-nix
# TODO: Setup postgres
# TODO: Overwrite default system ssh ?
# TODO: lang version mgmt and system provided dfeaults from unstable?
{
  environment.pathsToLink = [ "/share/zsh/" ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  # common apple L
  # TODO: Fix brew issue with controlled taps being reset
  # TODO: Replace thunderbird with @esr
  homebrew = {
    enable = true;
    brews = [ ];
    casks = [
      "1password"
      "aircall"
      "figma"
      "orbstack"
      "slack"
      "spotify"
      "thunderbird"
      "whatsapp"
    ];
    masApps = { };
    whalebrews = [ ];
    onActivation.cleanup = "zap";
  };

  # symlink system packages to home manager zsh for completion access
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  services.nix-daemon.enable = true;

  # rosetta to run x86 on silicon
  system.activationScripts.extraActivation.text = ''
    softwareupdate --install-rosetta --agree-to-license
  '';

  system.stateVersion = 5;

  users.users = {
    martin = {
      name = "martin";
      home = "/Users/martin";
    };
  };
}
