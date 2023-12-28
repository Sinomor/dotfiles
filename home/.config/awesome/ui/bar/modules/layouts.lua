local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")

local L = {}

function L:create()
	return wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		{
			widget = wibox.container.margin,
			margins = 5,
			awful.widget.layoutbox {
				buttons = {
					awful.button({ }, 1, function() awful.layout.inc(1) end)
				}
			}
		}
	}
end

return L
