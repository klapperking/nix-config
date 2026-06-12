local settings = require("settings")

local icons = {
  sf_symbols = {
    apple = "􀣺",
    cpu = "􀫥",
    volume = {
      _100 = "􀊩",
      _66  = "􀊧",
      _33  = "􀊥",
      _10  = "􀊡",
      _0   = "􀊣",
    },
    battery = {
      _100     = "􀛨",
      _75      = "􀺸",
      _50      = "􀺶",
      _25      = "􀛩",
      _0       = "􀛪",
      charging = "􀢋",
    },
    wifi = {
      strength_4 = "􀙇",
      strength_3 = "􀙇",
      strength_2 = "􀙇",
      strength_1 = "􀙇",
      off        = "􀙈",
    },
    network = {
      up   = "↑",
      down = "↓",
    },
    space = {
      focused = "●",
      normal  = "○",
    },
  },

  nerdfont = {
    apple    = "\u{F179}",
    cpu      = "\u{F2DB}",
    volume = {
      _100 = "\u{F028}",
      _66  = "\u{F027}",
      _33  = "\u{F027}",
      _10  = "\u{F026}",
      _0   = "\u{F026}",
    },
    battery = {
      _100     = "\u{F240}",
      _75      = "\u{F241}",
      _50      = "\u{F242}",
      _25      = "\u{F243}",
      _0       = "\u{F244}",
      charging = "\u{F0E7}",
    },
    wifi = {
      strength_4 = "\u{F0928}",
      strength_3 = "\u{F0925}",
      strength_2 = "\u{F0922}",
      strength_1 = "\u{F091F}",
      off        = "\u{F092E}",
    },
    network = {
      up   = "↑",
      down = "↓",
    },
    space = {
      focused = "●",
      normal  = "○",
    },
  },
}

if not (settings.icons == "NerdFont") then
  return icons.sf_symbols
else
  return icons.nerdfont
end