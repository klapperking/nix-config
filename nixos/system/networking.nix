{ ... }:
{
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    useDHCP = false;
  };

  # nss-mdns for `.local` resolution — Omarchy default.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
