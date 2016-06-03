
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

local charging_icon = ""

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
    local find_charging = string.match(read_text, "charged")
    local wanted = {string.match(read_text, "(%d+):(%d+)")} -- match hours and minutes only

    local selected_icon = icons[ (tonumber(wanted[1]) or 0)+1 ] or icons[#icons]
    local selected_color = colors[ (tonumber(wanted[1]) or 0) +1 ] or colors[#colors]

    if wanted[1] == nil and wanted[2] == nil then -- if its full
      batterywidget:set_markup(string.format("<span color='%s'>%s</span> ", colors[#colors], charging_icon))
    else
      if find_charging ~= "charged" then
        batterywidget:set_markup(string.format("<span color='%s'>%s</span> %sh %sm", selected_color, selected_icon, wanted[1], wanted[2]))
      else
        batterywidget:set_markup(string.format("<span color='%s'>%s</span> %sh %sm", colors[#colors], charging_icon, wanted[1], wanted[2]))
      end
    end

    fh:close()
  end
)
batterywidgettimer:start()

return batterywidget
