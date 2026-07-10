{ ... }:
{
  # BTRFS root with subvolumes. Device UUIDs are placeholders — replace on
  # target install via:
  #
  #   blkid | grep -E 'btrfs|vfat'
  #
  # Layout expected by this config:
  #   /dev/root-part → btrfs   → subvols: @ @home @nix @snapshots
  #   /dev/esp-part  → vfat    → mounted at /boot
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE_WITH_ROOT_UUID";
    fsType = "btrfs";
    options = [
      "subvol=@"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/REPLACE_WITH_ROOT_UUID";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/REPLACE_WITH_ROOT_UUID";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/REPLACE_WITH_ROOT_UUID";
    fsType = "btrfs";
    options = [
      "subvol=@snapshots"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE_WITH_ESP_UUID";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # Swap deferred. For FIDO2-unlock hibernation, add a swapfile inside the
  # btrfs @swap subvolume once you have hardware to test with.
  swapDevices = [ ];
}
