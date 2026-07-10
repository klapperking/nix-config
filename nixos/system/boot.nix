{ ... }:
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    # Systemd initrd is required for LUKS FIDO2 unlock via systemd-cryptenroll.
    # See ~/Downloads/security-hardened-secrets-runbook(1).md §Phase 1.
    initrd.systemd.enable = true;

    # LUKS device unlock. Enrollment (deferred to hardening PR):
    #
    #   sudo systemd-cryptenroll /dev/<luks-part> \
    #     --fido2-device=auto \
    #     --fido2-with-client-pin=yes
    #
    # After enrollment, uncomment `crypttabExtraOpts` below to auto-prompt for
    # the YubiKey at boot.
    initrd.luks.devices = {
      # "root" = {
      #   device = "/dev/disk/by-uuid/REPLACE_WITH_LUKS_UUID";
      #   crypttabExtraOpts = [ "fido2-device=auto" ];
      # };
    };

    # Boot splash. quiet+splash gives you Omarchy's boot experience.
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };
}
