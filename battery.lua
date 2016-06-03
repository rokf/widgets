
-- my battery widget for awesome wm
local wibox = require("wibox")

local batterywidget = wibox.widget.textbox()

local commands = {
  "acpi | cut -d, -f 2", -- percents left
  "acpi | cut -d, -f 2,3", -- percents and timer
  "acpi | cut -d, -f 3", -- timer
}

local icons = {
  "","","","",""
}

local colors = {
  "#e6db74",
  "#595959",
  "#595959",
  "#595959",
  "#89bdff",
}

batterywidget:set_text(icons[#icons])
batterywidgettimer = timer({ timeout = 5 })
batterywidgettimer:connect_signal("timeout",
  function()
    fh = assert(io.popen("acpi | cut -d, -f 3", "r"))
    local read_text = fh:read("*l")
    local wanted = {string.match(read_text, "(%d+):(%d+)")} -- match hours and minutes only
    local selected_icon = icons[ tonumber(wanted[1])+1 ] or icons[#icons]
    local selected_color = colors[ tonumber(wanted[1])+1 ] or colors[#colors]
    batterywidget:set_markup(string.format("<span color='%s'>%s</span> %sh %sm", selected_color, selected_icon, wanted[1], wanted[2]))
    fh:close()
  end
)
batterywidgettimer:start()

return batterywidget
