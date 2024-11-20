{ pkgs, config, ... }:

# TODO: All system settings - hide dock etc.

# TODO: Setup postgres
# TODO: Overwrite default system ssh ?
# TODO: lang version mgmt and system provided dfeaults from unstable?
{
  # symlink system packages to home manager zsh for completion access
  environment.pathsToLink = [ "/share/zsh/" ];

  environment.systemPackages = with pkgs; [
    vim
    devenv
  ];

  homebrew = {
    enable = true;
    # use taps declared by nix-homebrew
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [
      "hasura-cli"
    ];
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
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };

  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  services.nix-daemon.enable = true;

  system = {
    # rosetta to run x86 on silicon
    activationScripts.extraActivation.text = ''
      softwareupdate --install-rosetta --agree-to-license
    '';

    defaults = {
      ActivityMonitor.IconType = 5;
      # cpu usage icon
      controlcenter = {
        BatteryShowPercentage = true;
      };

      dock = {
        autohide = true;
        launchanim = false;
        largesize = 54;
        persistent-apps = [
          "/Applications/WhatsApp.app"
          "/Applications/Slack.app"
          "/Applications/Thunderbird.app"
          "${pkgs.firefox-devedition-bin}/Applications/Firefox Developer Edition.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "${pkgs.vscodium}/Applications/VSCodium.app"
          "${pkgs.kitty}/Applications/kitty.app"
        ];
        persistent-others = [ ];

        show-recents = false;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXPreferredViewStyle = "clmv";
        QuitMenuItem = true;
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowPathbar = true;
      };

      loginwindow = {
        GuestEnabled = false;
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        AppleTemperatureUnit = "Celsius";
        InitialKeyRepeat = 5; # TODO: Play around with this
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        "com.apple.keyboard.fnState" = true;
        "com.apple.mouse.tapBehavior" = 1; # duplicate of trackpad.Clicking?
      };

      trackpad = {
        Clicking = true;
        FirstClickThreshold = 0;
        SecondClickThreshold = 0;
        TrackpadRightClick = true;
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
