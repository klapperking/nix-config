local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local battery = sbar.add("item", "battery", {
  position = "right",
  update_freq = 60,
  icon = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 13.0,
    },
    color = colors.green,
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

local function update_battery(env)
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = icons.battery._100
    local color = colors.green
    local icon_size = 13.0
    local icon_y_offset = 0

    local percent = tonumber(batt_info:match("(%d+)%%"))
    if percent == nil then return end

    if batt_info:match("%; charging;") then
      icon = icons.battery.charging
      color = colors.yellow
      icon_size = 12.0
      icon_y_offset = -1
    elseif percent <= 10 then
      icon = icons.battery._0
      color = colors.red
    elseif percent <= 30 then
      icon = icons.battery._25
      color = colors.orange
    elseif percent <= 60 then
      icon = icons.battery._50
      color = colors.white
    elseif percent <= 80 then
      icon = icons.battery._75
      color = colors.green
    else
      icon = icons.battery._100
      color = colors.green
    end

    battery:set({
      icon = {
        string = icon,
        color = color,
        font = {
          family = settings.font.text,
          style = settings.font.style_map["Regular"],
          size = icon_size,
        },
        y_offset = icon_y_offset,
      },
      label = { string = percent .. "%" },
    })
  end)
end

battery:subscribe({ "routine", "power_source_change", "system_woke" }, update_battery)
