local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")

local Launcher = require("ui.launcher")
local L = {}

L.text = wibox.widget {
	widget = wibox.widget.textbox,
	text = "",
	halign = "center",
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 1)
}

function L:create_v()
	self.widget = wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		{
			widget = wibox.container.margin,
			margins = { top = 8, bottom = 8 },
			self.text
		}
	}
	return self.widget
end

function L:create_h()
	self.widget =  wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		{
			widget = wibox.container.margin,
			margins = { right = 8, left = 8 },
			self.text
		}
	}
	return self.widget
end

L.text:buttons {
	awful.button({}, 1, function()
		Launcher:toggle()
	end)
}

return L
