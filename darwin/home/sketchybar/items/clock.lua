local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local clock = sbar.add("item", "clock", {
  position = "right",
  update_freq = 30,
  icon = {
    string = icons.clock,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 13.0,
    },
    color = colors.grey,
    padding_right = 2,
  },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 13.0,
    },
    color = colors.white,
  },
})

clock:subscribe({ "routine", "forced" }, function(env)
  clock:set({
    icon = { string = os.date("%a %d %b") },
    label = { string = os.date("%H:%M") },
  })
end)
