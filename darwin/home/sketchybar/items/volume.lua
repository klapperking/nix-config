local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local volume = sbar.add("item", "volume", {
  position = "right",
  width = 30,
  update_freq = 5,
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

local function icon_for_level(level)
  if level == 0 then
    return icons.volume._0
  elseif level < 10 then
    return icons.volume._10
  elseif level < 40 then
    return icons.volume._33
  elseif level < 70 then
    return icons.volume._66
  else
    return icons.volume._100
  end
end

local function poll_volume()
  sbar.exec("osascript -e 'output volume of (get volume settings)'", function(result)
    local level = tonumber(result)
    if level then
      volume:set({ icon = { string = icon_for_level(level) } })
    end
  end)
end

volume:subscribe("volume_change", function(env)
  local level = tonumber(env.INFO) or 0
  volume:set({ icon = { string = icon_for_level(level) } })
end)

volume:subscribe({ "routine", "forced" }, function(env)
  poll_volume()
end)
