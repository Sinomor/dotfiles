local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local Control = require("ui.control")
local C = {}

C.button = gears.table.join (
	awful.button({}, 1, function()
		Control:toggle("moment")
	end)
)

function C:create_v()
	self.widget = wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		buttons = self.button,
		{
			widget = wibox.container.margin,
			margins = { top = 6, bottom = 6 },
			{
				widget = wibox.widget.textclock,
				format = "%H\n%M\n%S",
				refresh = 1,
				halign = "center"
			}
		}
	}
	return self.widget
end

function C:create_h()
	self.widget = wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		buttons = self.button,
		{
			widget = wibox.container.margin,
			margins = { left = 8, right = 8 },
			{
				widget = wibox.widget.textclock,
				format = "%H:%M:%S",
				refresh = 1,
				halign = "center"
			}
		}
	}
	return self.widget
end

return C
