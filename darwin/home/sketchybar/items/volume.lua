local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local volume = sbar.add("item", "volume", {
  position = "right",
  icon = {
    string = icons.volume._66,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 13.0,
    },
    color = colors.white,
  },
  label = { drawing = false },
})

local function update_volume(env)
  local level = tonumber(env.INFO) or 0
  local icon

  if level == 0 then
    icon = icons.volume._0
  elseif level < 10 then
    icon = icons.volume._10
  elseif level < 40 then
    icon = icons.volume._33
  elseif level < 70 then
    icon = icons.volume._66
  else
    icon = icons.volume._100
  end

  volume:set({
    icon = { string = icon },
  })
end

volume:subscribe("volume_change", update_volume)
