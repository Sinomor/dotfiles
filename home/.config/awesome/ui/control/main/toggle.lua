local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")

local function create_toggle(args)

	local icon = wibox.widget {
		widget = wibox.widget.textbox,
		text = args.icon,
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 9),
		halign = "center"
	}

	local value = wibox.widget {
		widget = wibox.widget.textbox,
		text = args.value
	}

	local name = wibox.widget {
		widget = wibox.widget.textbox,
		text = args.name
	}

	local icon_container = wibox.widget {
		widget = wibox.container.background,
		bg = args.bg,
		fg = args.fg,
		buttons = {
		awful.button({}, 1, function()
			args.click_func()
		end)
		},
		{
			widget = wibox.container.margin,
			margins = 10,
			icon
		}
	}

	local toggle_layout = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 15,
		{
			widget = wibox.container.margin,
			margins = { left = 10, top = 10, bottom = 10 },
			icon_container,
		},
		{
			widget = wibox.container.place,
			{
				layout = wibox.layout.fixed.vertical,
				name,
				value,
			}
		}
	}

	local toggle = wibox.widget {
		widget = wibox.container.background,
		forced_width = 230,
		forced_height = 76,
		bg = beautiful.bg_alt,
		toggle_layout,
	}

	local arroy = wibox.widget {
		widget = wibox.widget.textbox,
		text = "",
		forced_width = 80,
		halign = "right",
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 12),
		buttons = {
			awful.button({ }, 1, args.arroy_func),
		}
	}
	if args.arroy_visible then
		toggle_layout:insert(3, arroy)
	end

	toggle.change_value = function(state)
		value.text = state
	end

	toggle.change_color = function(from_fg, to_fg, from_bg, to_bg)
		helpers.ui.transitionColor {
			old = from_bg,
			new = to_bg,
			transformer = function(col)
				icon_container:set_bg(col)
			end,
			duration = 0.8
		}
		helpers.ui.transitionColor {
			old = from_fg,
			new = to_fg,
			transformer = function(col)
				icon_container:set_fg(col)
			end,
			duration = 0.8
		}
	end

	toggle.change = function(x)
		if x == "off" then
			toggle.change_value("Off")
			toggle.change_color(beautiful.bg, beautiful.fg, beautiful.accent, beautiful.bg_urgent)
		else
			toggle.change_value("On")
			toggle.change_color(beautiful.fg, beautiful.bg, beautiful.bg_urgent, beautiful.accent)
		end
	end

	if args.value == "on" then
		toggle.change("on")
	else
		toggle.change("off")
	end

	return toggle
end

return create_toggle
