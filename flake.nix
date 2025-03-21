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

    # Replace after: https://github.com/zhaofengli/nix-homebrew/issues/70 closes
    nix-homebrew.url = "git+https://github.com/zhaofengli/nix-homebrew?ref=refs/pull/71/merge";
    # nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

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
                taps = with inputs; {
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
              ];
              home-manager.extraSpecialArgs = { inherit (specialArgs) pkgs-stable; };
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
                inputs.sops-nix.homeManagerModules.sops
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.martin = import ./darwin/home/home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
      };
    };
}
