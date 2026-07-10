{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform,WaylandWindowDecorations"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
    ];
    # TODO Phase 2b: sideload the Omarchy `copy-url` extension by fetching
    # `default/chromium/extensions/copy-url/` from basecamp/omarchy into a
    # nix-store path and passing `--load-extension=<path>` above.
    extensions = [
      # 1Password
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa"
      # Bitwarden
      "nngceckbapebfimnlniiiahkandclblb"
      # uBlock Origin
      "cjpalhdlnbpafiamejdnhcphjbkeiagm"
    ];
  };
}
