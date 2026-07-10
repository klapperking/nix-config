{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # === Omarchy default desktop apps ===
    imv
    evince
    gnome-calculator
    gnome-disk-utility
    kdePackages.kdenlive
    libreoffice-fresh
    localsend
    obs-studio
    pinta
    signal-desktop
    spotify
    xournalpp
    # typora is available in nixpkgs as `typora` (unfree)
    typora

    # === File manager stack (Nautilus python extensions deferred to Phase 2b) ===
    nautilus
    sushi
    ffmpegthumbnailer
    gvfs

    # === Omarchy CLI / TUI tooling ===
    fastfetch
    bluetui
    impala
    lazygit
    lazydocker
    dua
    brightnessctl
    playerctl
    pamixer
    wiremix
    swayosd
    swaybg
    gum
    eza
    fd
    bat
    tldr
    tree-sitter
    unzip
    xmlstarlet

    # === Hyprland ecosystem tools ===
    # Used by Phase 2a keybinds inline (grim / slurp / hyprpicker chains).
    # Phase 2b will wrap them in omarchy-* pkgs.writeShellApplication ports.
    hyprpicker
    satty
    grim
    slurp
    wl-clipboard
    tesseract
    gpu-screen-recorder
  ];
}
