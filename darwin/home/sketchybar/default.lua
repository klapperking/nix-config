local settings = require("settings")
local colors = require("colors")

sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 13.0,
    },
    color = colors.white,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
  },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 13.0,
    },
    color = colors.white,
    padding_left = settings.paddings,
    padding_right = settings.paddings,
  },
  background = {
    height = 26,
    corner_radius = 0,
    border_width = 0,
  },
  popup = {
    background = {
      border_width = 1,
      corner_radius = 0,
      border_color = colors.popup.border,
      color = colors.popup.bg,
      shadow = { drawing = false },
    },
    blur_radius = 0,
  },
  padding_left = 3,
  padding_right = 3,
  scroll_texts = false,
})