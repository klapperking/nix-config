{ pkgs, ... }:
{
  # Hyprland session, launched under uwsm (matches Omarchy's
  # `uwsm start ... Hyprland`).
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.uwsm.enable = true;

  # SDDM with Wayland + autologin. Matches Omarchy's
  # `install/login/sddm.sh` behavior.
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
    };
    autoLogin = {
      enable = true;
      user = "martin";
    };
    defaultSession = "hyprland-uwsm";
  };

  # XDG portal: Hyprland module registers its own portal; add GTK portal for
  # GNOME apps (Nautilus, GNOME Calculator).
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Wayland environment variables applied session-wide.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # dconf backs many GTK settings; required for Nautilus and GNOME apps.
  programs.dconf.enable = true;

  # gnome-keyring is unused (KeePassXC is the secret provider per runbook),
  # but polkit is needed by GUI privilege prompts.
  security.polkit.enable = true;

  # pcscd for YubiKey PIV/OpenPGP applets — runbook §Phase 1.
  services.pcscd.enable = true;
}
