local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")

local B = {}

B.battery_progressbar = wibox.widget {
	widget = wibox.widget.progressbar,
	max_value = 100,
	forced_width = 80,
	background_color = beautiful.bg_urgent,
}

B.battery_charge_icon = wibox.widget {
	widget = wibox.widget.textbox,
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 11),
	halign = "center",
	valign = "center"
}

function B:create_v()
	self.widget = wibox.widget {
		layout = wibox.layout.stack,
		{
			widget = wibox.container.rotate,
			direction = "east",
			self.battery_progressbar
		},
		self.battery_charge_icon
	}
	return self.widget
end

function B:create_h()
	self.widget = wibox.widget {
		layout = wibox.layout.stack,
		B.battery_progressbar,
		B.battery_charge_icon
	}
	return self.widget
end

awesome.connect_signal("signal::battery", function(value, state)
	B.battery_progressbar.value = value
	if value > 70 then
		B.battery_progressbar.color = beautiful.green
	elseif value > 20 then
		B.battery_progressbar.color = beautiful.yellow
	else
		B.battery_progressbar.color = beautiful.red
	end
	if state == "Discharging" then
		B.battery_charge_icon.markup = ""
	else
		B.battery_progressbar.color = beautiful.green
		if value < 45 then
			B.battery_charge_icon.markup = helpers.ui.colorizeText("󱐋", beautiful.fg_alt)
		else
			B.battery_charge_icon.markup = helpers.ui.colorizeText("󱐋", beautiful.bg)
		end
	end
end)

return B
