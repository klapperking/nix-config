# =============================================================================
# STUB — regenerate on the target machine after installing NixOS:
#
#   sudo nixos-generate-config --root /mnt
#
# Then copy the produced /mnt/etc/nixos/hardware-configuration.nix over this
# file. Everything in this stub is placeholder so the flake evaluates for
# offline development.
# =============================================================================
{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd = {
    availableKernelModules = [ ];
    kernelModules = [ ];
  };
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
