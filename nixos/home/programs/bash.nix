{ ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      # `ll`, `la`, `ls` are managed by programs.lsd via home.shellAliases
      # (see shared/home/programs/default.nix). Adding them here creates a
      # conflict on `home-manager.users.martin.programs.bash.shellAliases.la`.
      cat = "bat";
      grep = "grep --color=auto";
    };
    initExtra = ''
      export EDITOR=nvim
      export VISUAL=nvim
      export TERMINAL=alacritty
    '';
  };
}
