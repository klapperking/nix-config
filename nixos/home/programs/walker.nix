{ ... }:
let
  theme = import ../theme/tokyo-night.nix;
in
{
  # Walker has no home-manager module; drop configs via xdg.configFile.
  xdg.configFile."walker/config.toml".text = ''
    theme = "omarchy-default"

    [providers.default]
    prefix = ""

    [providers.applications]
    prefix = ""
    show_icon_when_single = true
    show_generic = false

    [providers.clipboardmanager]
    prefix = "cm"
    max_entries = 20
    time_format = "kitchen"

    [providers.calc]
    prefix = "="

    [providers.commands]
    prefix = ":"

    [providers.finder]
    prefix = "/"

    [providers.runner]
    prefix = "!"

    [providers.symbols]
    prefix = ".e"

    [providers.websearch]
    prefix = "?"

    [keys.activation_modifiers]
    ctrl = "shift"
    alt = "alt"
  '';

  xdg.configFile."walker/themes/omarchy-default/style.css".text = ''
    * {
      font-family: "${theme.fonts.monospace}";
      font-size: 14px;
    }

    #window {
      background: ${theme.colors.bg};
      color: ${theme.colors.fg};
      border: 2px solid ${theme.colors.accent};
      border-radius: 12px;
      padding: 12px;
    }

    #input {
      background: ${theme.colors.bg_dark};
      color: ${theme.colors.fg};
      padding: 8px 12px;
      border-radius: 6px;
      caret-color: ${theme.colors.accent};
    }

    #list {
      background: transparent;
    }

    .item {
      padding: 6px 12px;
      border-radius: 4px;
    }

    .item:selected {
      background: ${theme.colors.accent};
      color: ${theme.colors.bg};
    }

    .item .label {
      color: ${theme.colors.fg};
    }

    .item:selected .label {
      color: ${theme.colors.bg};
    }
  '';

  xdg.configFile."walker/themes/omarchy-default/layout.toml".text = ''
    [ui.window]
    hide_qs = false
  '';
}
