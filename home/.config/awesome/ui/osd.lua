local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local rubato = require("modules.rubato")

local Osd = {}

Osd.icon = wibox.widget {
	widget = wibox.widget.textbox,
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 3),
}

Osd.value_text = wibox.widget {
	widget = wibox.widget.textbox,
	halign = "center"
}

Osd.progressbar = wibox.widget {
	widget = wibox.widget.progressbar,
	max_value = 100,
	forced_height = 10,
	background_color = beautiful.bg_urgent,
	color = beautiful.accent,
}

Osd.main_widget = wibox.widget {
	widget = wibox.container.margin,
	margins = 20,
	{
		layout = wibox.layout.fixed.horizontal,
		fill_space = true,
		spacing = 8,
		Osd.icon,
		{
			widget = wibox.container.background,
			forced_width = 36,
			Osd.value_text,
		},
		Osd.progressbar,
	}
}

Osd.popup = awful.popup {
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	minimum_height = 60,
	maximum_height = 60,
	minimum_width = 290,
	maximum_width = 290,
	placement = function(d)
		awful.placement.bottom(d, {
			margins = beautiful.useless_gap * 4 + beautiful.border_width * 2
		})
	end,
	widget = Osd.main_widget,
}

-- volume --

awesome.connect_signal("signal::volume", function(value, icon)
	Osd.progressbar.value = value
	Osd.value_text.text = value
	Osd.icon.text = icon
end)

-- bright --

awesome.connect_signal("signal::bright", function(value, icon)
	Osd.progressbar.value = value
	Osd.value_text.text = value
	Osd.icon.text = icon
end)

function Osd:close()
	self.popup.visible = false
	self.timer:stop()
end

Osd.timer = gears.timer {
	timeout = 3,
	callback = function()
		Osd:close()
	end
}

function Osd:open()
	if self.popup.visible then
		self.timer:again()
	else
		self.popup.visible = true
		self.timer:start()
	end
end

return Osd
