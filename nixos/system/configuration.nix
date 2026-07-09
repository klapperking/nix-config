{ ... }:
{
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./audio.nix
    ./desktop.nix
    ./fonts.nix
    ./users.nix
    ./packages.nix
    ./sops.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    substituters = [
      "https://cache.nixos.org/"
    ];
  };

  # Pinned to match nixpkgs-stable-2511. Do NOT bump without reading:
  # https://nixos.org/manual/nixos/stable/#sec-upgrading
  system.stateVersion = "25.11";
}
