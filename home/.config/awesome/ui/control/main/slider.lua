local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")

local function create_slider(args)

	local slider = wibox.widget {
		widget = wibox.widget.slider,
		maximum = 100,
		bar_color = beautiful.bg_alt .. "00",
		bar_active_color = args.color,
		handle_width = -8,
	}

	local line = wibox.widget {
		widget = wibox.container.background,
		forced_height = beautiful.border_width,
		bg = beautiful.border_color_normal,
	}

	local slider_icon = wibox.widget {
		widget = wibox.widget.textbox,
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 2),
		halign = "center",
	}

	local widget = wibox.widget {
		widget = wibox.container.background,
		fg = beautiful.bg,
		forced_height = 35,
		{
			layout = wibox.layout.stack,
			{
				widget = wibox.container.place,
				valign = "center",
				line,
				content_fill_vertical = false,
				content_fill_horizontal = true,
			},
			slider,
			{
				widget = wibox.container.place,
				halign = "left",
				{
					widget = wibox.container.margin,
					left = 8,
					slider_icon,
				}
			}
		}
	}

	awesome.connect_signal(args.signal, function(value, icon)
		slider.value = value
		slider_icon.text = icon
	end)

	slider:connect_signal("button::press", function()
		slider:connect_signal("property::value", function(_, new_value)
			awful.spawn.with_shell(string.format(args.command, new_value))
		end)
	end)

	return widget
end

return create_slider
