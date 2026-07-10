{ ... }:
{
  # PipeWire stack matching Omarchy defaults.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth with A2DP autoconnect (Omarchy ships a wireplumber.conf.d rule
  # for this; NixOS's bluetooth Experimental flag has the same effect).
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
    };
  };

  services.blueman.enable = true;
}
