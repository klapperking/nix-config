{ pkgs, ... }:

let
  sketchybarHelpers = import ../../../nix/sketchybar-helpers.nix { inherit pkgs; };
in
{
  home.file = {
    # Deploy the Lua config files
    ".config/sketchybar" = {
      source = ./.;
      recursive = true;
      onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
    };

    # Symlink sbarlua module
    ".local/share/sketchybar_lua/sketchybar.so" = {
      source = "${pkgs.sbarlua}/lib/lua/${pkgs.lua54Packages.lua.luaversion}/sketchybar.so";
      onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
    };

    # Generate sketchybarrc entry point
    ".config/sketchybar/sketchybarrc" = {
      text = ''
        #!/usr/bin/env ${pkgs.lua54Packages.lua}/bin/lua
        -- Load the sketchybar-package and prepare the helper binaries
        require("helpers")
        require("init")
      '';
      executable = true;
      onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
    };

    # Symlink pre-compiled helper binaries
    ".config/sketchybar/helpers/event_providers/cpu_load/bin/cpu_load" = {
      source = "${sketchybarHelpers}/bin/cpu_load";
    };
    ".config/sketchybar/helpers/event_providers/network_load/bin/network_load" = {
      source = "${sketchybarHelpers}/bin/network_load";
    };
    ".config/sketchybar/helpers/menus/bin/menus" = {
      source = "${sketchybarHelpers}/bin/menus";
    };
  };
}
