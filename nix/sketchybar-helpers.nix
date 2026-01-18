{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "sketchybar-helpers";
  src = ../darwin/home/sketchybar/helpers;

  nativeBuildInputs = with pkgs; [ clang ];

  buildPhase = ''
    # Build cpu_load
    mkdir -p event_providers/cpu_load/bin
    clang -std=c99 -O3 event_providers/cpu_load/cpu_load.c \
      -o event_providers/cpu_load/bin/cpu_load

    # Build network_load
    mkdir -p event_providers/network_load/bin
    clang -std=c99 -O3 event_providers/network_load/network_load.c \
      -o event_providers/network_load/bin/network_load

    # Build menus (requires Carbon and SkyLight frameworks)
    mkdir -p menus/bin
    clang -std=c99 -O3 \
      -F/System/Library/PrivateFrameworks/ \
      -framework Carbon \
      -framework SkyLight \
      menus/menus.c -o menus/bin/menus
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp event_providers/cpu_load/bin/cpu_load $out/bin/
    cp event_providers/network_load/bin/network_load $out/bin/
    cp menus/bin/menus $out/bin/
  '';

  meta = with pkgs.lib; {
    description = "Compiled C helper binaries for SketchyBar";
    platforms = platforms.darwin;
  };
}
