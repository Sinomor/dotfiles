local beautiful = require("beautiful")
local wibox = require("wibox")

local C = {}

function C:create_v()
	self.widget = wibox.widget {
		widget = wibox.container.background,
		state = false,
		bg = beautiful.bg_alt,
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
		state = false,
		bg = beautiful.bg_alt,
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