{
  description = "5head config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable-2411.url = "github:NixOS/nixpkgs/release-24.11";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    mac-app-util.url = "github:hraban/mac-app-util";
    sops-nix.url = "github:Mic92/sops-nix";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # too lazy to make actual own derivation, all credits to: https://github.com/Lalit64 &  https://github.com:gangjun06
    sbarlua = {
      url = "github:lalit64/SbarLua/nix-darwin-package";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-stable-2411,
      home-manager,
      darwin,
      mac-app-util,
      nix-homebrew,
      ...
    }:
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
      darwinConfigurations = {
        pro = darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";
          specialArgs = {
            pkgs-stable = import nixpkgs-stable-2411 {
              inherit system;
              # TODO: Move this to configuration.nix?
              config.allowUnfree = true;
            };
          };
          modules = [
            ./darwin/system/configuration.nix
            mac-app-util.darwinModules.default
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "martin";
                autoMigrate = true;
                taps = {
                  "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                  "homebrew/homebrew-core" = inputs.homebrew-core;
                  "homebrew/homebrew-cask" = inputs.homebrew-cask;
                };
                mutableTaps = false;
              };
            }
            home-manager.darwinModules.home-manager
            {
              nixpkgs.overlays = [
                inputs.nur.overlays.default
                inputs.sbarlua.overlay
              ];
              home-manager = {
                extraSpecialArgs = {
                  inherit (specialArgs) pkgs-stable;
                };

                sharedModules = [
                  mac-app-util.homeManagerModules.default
                  inputs.sops-nix.homeManagerModules.sops
                ];

                useGlobalPkgs = true;
                useUserPackages = true;
                users.martin = {
                  imports = [
                    ./darwin/home/home.nix
                    ./darwin/home/sketchybar/sketchybar.nix
                  ];
                };
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };
    };
}
