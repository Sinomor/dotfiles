local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")

local T = {}

T.tray = wibox.widget {
	state = false,
	widget = wibox.container.constraint,
	strategy = "max",
	height = 0,
	{
		widget = wibox.container.margin,
		margins = { top = 8, bottom = 8 },
		{
			widget = wibox.widget.systray,
			horizontal = false,
			base_size = 24
		}
	}
}

T.tray_button = wibox.widget {
	widget = wibox.widget.textbox,
	text = "",
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 5),
	halign = "center",
}

T.widget = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.bg_alt,
	{
		layout = wibox.layout.fixed.vertical,
		{
			widget = wibox.container.margin,
			margins = 2,
			T.tray_button
		},
		{
			widget = wibox.container.place,
			halign = "center",
			T.tray
		}
	}
}

function T:create_v()
	return self.widget
end


function T:create_h()
	return wibox.widget {
		widget = wibox.container.rotate,
		direction = "east",
		self.widget
	}
end

function T:toggle()
	if not self.tray.state then
		self.tray_button.text = ""
		self.tray.height = 200
	else
		self.tray_button.text = ""
		self.tray.height = 0
	end
	self.tray.state = not self.tray.state
end

T.widget:buttons{
	awful.button({}, 1, function()
		T:toggle()
	end)
}

return T
