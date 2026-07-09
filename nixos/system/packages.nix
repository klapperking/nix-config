{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    pciutils
    usbutils
    file
    tree
  ];

  # Docker (Omarchy ships docker + buildx + compose).
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  services.tailscale.enable = true;

  # OpenSSH is required so sops-nix can derive the host age recipient from
  # /etc/ssh/ssh_host_ed25519_key. Password auth off by default; keys only.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
    openFirewall = false;
  };
}
