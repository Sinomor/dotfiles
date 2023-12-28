local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")

local K = {}

K.text = awful.widget.keyboardlayout()
K.text.widget.text = string.upper(K.text.widget.text)
K.text.widget.halign = "center"
K.text.widget:connect_signal("widget::redraw_needed", function(wid)
	wid.text = string.upper(wid.text)
end)

function K:create_v()
	return wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		{
			widget = wibox.container.margin,
			margins = { top = 8, bottom = 8, left = -4, right = -4 },
			self.text
		}
	}
end

function K:create_h()
	return wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		{
			widget = wibox.container.margin,
			margins = { left = -4, right = -4 },
			self.text
		}
	}
end

return K
