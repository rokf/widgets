-- my wifi widget for awesome wm
local wibox = require("wibox")

local wifiwidget = wibox.widget.textbox() -- create

-- config
local color = "#89bdff"
local color_bad = "#a6a6a6"
local command = "cat /proc/net/wireless"
local icon = ""

wifiwidget:set_text(icon) -- initial text
wifiwidgettimer = timer({ timeout = 5 })
wifiwidgettimer:connect_signal("timeout",
  function()
    local fh = assert(io.popen(command, "r")) -- file handle
    local read_text = fh:read("*a")
    local strength = string.match(read_text, "(%d+)%.")
    if strength ~= nil then
      wifiwidget:set_markup(string.format("<span color='%s'>%s</span> %s ", color, icon, strength))
    else
      wifiwidget:set_markup(string.format("<span color='%s'>%s</span> ", color_bad, icon))
    end
    fh:close()
  end
)
wifiwidgettimer:start()

return wifiwidget
