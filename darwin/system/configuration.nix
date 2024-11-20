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
  # homebrew = {
  #   enable = true;
  #   # taps = [
  #   #   "homebrew/homebrew-core"
  #   #   "homebrew/cask"
  #   #   "homebrew/homebrew-bundle"
  #   # ];
  #   brews = [ ];
  #   # casks = [
  #   #   "1password"
  #   #   "aircall"
  #   #   "figma"
  #   #   "orbstack"
  #   #   "slack"
  #   #   "spotify"
  #   #   # "thunderbird@esr"
  #   #   "whatsapp"
  #   # ];
  #   masApps = { };
  #   # whalebrews = [ ];
  #   onActivation = {
  #     autoUpdate = true;
  #     upgrade = true;
  #     cleanup = "zap";
  #   };
  # };

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

  system = {
    # rosetta to run x86 on silicon
    activationScripts.extraActivation.text = ''
      softwareupdate --install-rosetta --agree-to-license
    '';

    defaults = {
      dock = {
        autohide = true;
        # TODO: Persistent apps
        # persistent-apps = [

        # ];
      };
    };

    stateVersion = 5;
  };

  users.users = {
    martin = {
      name = "martin";
      home = "/Users/martin";
    };
  };
}
