{
  pkgs,
  pkgs-stable,
  ...
}:
{
  home.packages = with pkgs; [
    _1password-cli
    age
    bat
    bc
    # bitwarden-cli
    # TODO: Move back to unstable once nixpkgs#523142 (compiler-rt darwin fix) is merged
    # TODO: Re-enable after https://github.com/bitwarden/clients/pull/20448 closes (bitwarden electron upgrade)
    # pkgs-stable.bitwarden-desktop
    darwin.xcode_16
    discordo
    claude-code
    discord
    docker
    # firefox-devedition
    fzf
    fx
    jq
    gdu
    git
    gh-eco
    gnupg
    google-chrome
    google-cloud-sdk
    hyperfine
    kitty
    meslo-lgs-nf
    mqttui
    mutt
    nixd
    nixfmt
    nmap
    obsidian
    opencode
    osu-lazer-bin
    pinentry-tty
    postman
    prismlauncher
    rainfrog
    ripgrep
    raycast
    sbarlua
    shellcheck
    sketchybar-app-font
    speedtest-cli
    tailscale
    # TODO: Move back to unstable once nixpkgs#523142 (compiler-rt darwin fix) is merged
    pkgs-stable.telegram-desktop
    tmux
    tmuxPlugins.tokyo-night-tmux
    tmuxPlugins.yank
    ttyper
    vscodium
    zed-editor
    zsh
    zsh-powerlevel10k
  ];
}
