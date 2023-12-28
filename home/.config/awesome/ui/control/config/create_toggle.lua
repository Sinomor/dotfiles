local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local user = require("user")
local helpers = require("helpers")
local user_file = "~/.config/awesome/user.lua"

local function create_toggle(var, name)

	local text = wibox.widget {
		widget = wibox.widget.textbox,
		markup = name
	}

	local state_widget = wibox.widget {
		widget = wibox.container.background,
		forced_width = 30,
		bg = beautiful.bg,
		border_width = beautiful.border_width,
		border_color = beautiful.bg_urgent,
		{
			widget = wibox.container.background,
			id = "state",
			bg = beautiful.fg,
			border_width = beautiful.border_width * 3,
			border_color = beautiful.bg_alt
		}
	}

	local function change_state()
		if user[var] then
			state_widget:get_children_by_id("state")[1]:set_bg(beautiful.fg)
			awful.spawn.easy_async_with_shell([[ sed -i -e "s/user.]] ..var.. [[ =.*/user.]] ..var.. [[ = true/g" ]] ..user_file)
		else
			state_widget:get_children_by_id("state")[1]:set_bg(beautiful.bg_alt)
			awful.spawn.easy_async_with_shell([[ sed -i -e "s/user.]] ..var.. [[ =.*/user.]] ..var.. [[ = false/g" ]] ..user_file)
		end
	end
	change_state()

	state_widget:buttons {
		awful.button({}, 1, function()
			user[var] = not user[var]
			change_state()
		end)
	}

	local widget = wibox.widget {
		layout = wibox.layout.align.horizontal,
		forced_height = 35,
		text,
		nil,
		{
			widget = wibox.container.margin,
			margins = { top = 5 },
			state_widget,
		}
	}

	return widget
end

return create_toggle
