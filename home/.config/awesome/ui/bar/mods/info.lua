local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")

local I = {}

I.wifi = wibox.widget {
	widget = wibox.container.background,
	{
		widget = wibox.widget.textbox,
		text = "",
		halign = "center",
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 1)
	}
}

I.dnd = wibox.widget {
	widget = wibox.container.background,
	{
		widget = wibox.widget.textbox,
		text = "",
		halign = "center",
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 1)
	}
}

I.bluetooth = wibox.widget {
	widget = wibox.container.background,
	{
		widget = wibox.widget.textbox,
		text = "",
		halign = "center",
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 1)
	}
}

function I:create_v()
	self.widget = wibox.widget {
		widget = wibox.container.background,
		state = false,
		bg = beautiful.bg_alt,
		buttons = self.button,
		{
			widget = wibox.container.margin,
			margins = { top = 8, bottom = 8 },
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 10,
				self.bluetooth,
				self.wifi,
				self.dnd
			}
		},
	}
	return self.widget
end

function I:create_h()
	self.widget = wibox.widget {
		widget = wibox.container.background,
		state = false,
		bg = beautiful.bg_alt,
		buttons = self.button,
		{
			widget = wibox.container.margin,
			margins = { left = 8, right = 8 },
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 10,
				self.bluetooth,
				self.wifi,
				self.dnd
			}
		},
	}
	return self.widget
end

awesome.connect_signal("signal::bluetooth", function(value)
	if value then
		I.bluetooth:set_fg(beautiful.fg)
	else
		I.bluetooth:set_fg(beautiful.fg_alt)
	end
end)

awesome.connect_signal("wifi:status", function(value)
	if value then
		I.wifi:set_fg(beautiful.fg)
	else
		I.wifi:set_fg(beautiful.fg_alt)
	end
end)

function I:dnd_toggle()
	if not naughty.is_suspended() then
		I.dnd:set_fg(beautiful.fg_alt)
		naughty.suspend()
	else
		I.dnd:set_fg(beautiful.fg)
		naughty.resume()
	end
end

return I
