{
  description = "Darwin configuration";

  inputs = {
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nur.url = "github:nix-community/NUR";
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
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      darwin,
      mac-app-util,
      nix-homebrew,
      ...
    }:
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
      darwinConfigurations = {
        pro = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin/system/configuration.nix
            mac-app-util.darwinModules.default
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "martin";
                taps = with inputs; {
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                };
                mutableTaps = false;
              };
            }
            home-manager.darwinModules.home-manager
            {
              nixpkgs.overlays = [
                inputs.nixpkgs-firefox-darwin.overlay
                inputs.nur.overlays.default
              ];
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
                inputs.sops-nix.homeManagerModules.sops
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.martin = import ./darwin/home/home.nix;
            }
          ];
        };
      };
    };
}
