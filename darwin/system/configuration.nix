{
  pkgs,
  config,
  ...
}:

# TODO: Setup system postgres
# TODO: Overwrite default system ssh ?fir
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
    caskArgs = {
      require_sha = true;
    };
    casks = [
      {
        name = "1password";
        greedy = true;
      }
      {
        name = "aircall";
        greedy = true;
      }
      {
        name = "bitwarden";
        greedy = true;
      }
      {
        name = "discord";
        greedy = true;
      }
      {
        name = "linear-linear";
        greedy = true;
      }
      {
        name = "figma";
        greedy = true;
      }
      {
        name = "orbstack";
        greedy = true;
      }
      {
        name = "docker";
        greedy = true;
      }
      {
        name = "slack";
        greedy = true;
      }
      {
        name = "spotify";
        greedy = true;
      }
      {
        name = "thunderbird";
        greedy = true;
      }
      {
        name = "whatsapp";
        greedy = true;
      }
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
  nix.settings.substituters = [
    # default nixos cace
    "https://cache.nixos.org/"
    # devenv cache
    "https://devenv.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    # devenv cache
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    activationScripts = {
      # rosetta to run x86 on silicon
      extraActivation.text = ''
        softwareupdate --install-rosetta --agree-to-license
      '';
    };

    defaults = {
      ActivityMonitor.IconType = 5;
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
          "${pkgs.firefox-devedition-unwrapped}/Applications/Firefox Developer Edition.app"
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
        InitialKeyRepeat = 15;
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
