{
  config,
  pkgs,
  pkgs-stable,
  ...
}:
let
  oxker-colima = pkgs.writeShellApplication {
    name = "oxker";
    text = ''
      for arg in "$@"; do
        case "$arg" in
          --host|--host=*)
            exec ${pkgs-stable.oxker}/bin/oxker "$@"
            ;;
        esac
      done

      exec ${pkgs-stable.oxker}/bin/oxker \
        --host "unix://${config.home.homeDirectory}/.colima/default/docker.sock" \
        "$@"
    '';
  };
in
{
  home.packages = [
    oxker-colima
  ];
}
