local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

-- Module-level state for delta calculation (no state file needed)
local prev_tx = 0
local prev_rx = 0

local function format_bytes(bytes)
  if bytes < 1000 then
    return string.format("%dB", bytes)
  elseif bytes < 1000000 then
    return string.format("%.0fK", bytes / 1000)
  else
    return string.format("%.1fM", bytes / 1000000)
  end
end

local network = sbar.add("item", "network", {
  position = "right",
  update_freq = 2,
  icon = { drawing = false },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 12.0,
    },
    color = colors.white,
    string = icons.network.up .. "0B " .. icons.network.down .. "0B",
  },
})

network:subscribe({ "routine", "forced" }, function(env)
  sbar.exec("netstat -ibn | awk '/Link#/ && $1==\"en0\" {print $7, $10; exit}'", function(result)
    local tx_str, rx_str = result:match("(%d+)%s+(%d+)")
    if not tx_str then return end

    local tx = tonumber(tx_str) or 0
    local rx = tonumber(rx_str) or 0

    local tx_delta = 0
    local rx_delta = 0

    if prev_tx > 0 and tx >= prev_tx then
      tx_delta = (tx - prev_tx) / 2  -- divide by update_freq (2s)
    end
    if prev_rx > 0 and rx >= prev_rx then
      rx_delta = (rx - prev_rx) / 2
    end

    prev_tx = tx
    prev_rx = rx

    network:set({
      label = {
        string = icons.network.up .. format_bytes(tx_delta) .. " " .. icons.network.down .. format_bytes(rx_delta),
      },
    })
  end)
end)
