local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local launcher = sbar.add("item", "launcher", {
  position = "left",
  icon = {
    string = icons.apple,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 15.0,
    },
    color = colors.blue,
    padding_left = 6,
    padding_right = 6,
  },
  label = { drawing = false },
  background = { drawing = false },
  click_script = "open -a 'System Preferences'",
})
