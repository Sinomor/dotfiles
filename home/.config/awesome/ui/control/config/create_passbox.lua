local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local user = require("user")
local helpers = require("helpers")
local user_file = "~/.config/awesome/user.lua"

local function create_passbox(var, name)

	local len = string.len(user[var])

	local prompt = wibox.widget {
		widget = wibox.widget.textbox,
		markup = helpers.ui.size_text(string.rep("󰧞", len), 11)
	}

	local function get_input()
		awful.prompt.run({
			textbox = prompt,
			text = user[var],
			bg_cursor = beautiful.bg_alt,
			done_callback = function()
				prompt.markup = helpers.ui.size_text(string.rep("󰧞", len), 11)
			end,
			exe_callback = function(input)
				if not input or #input == 0 then
					prompt.markup = user[var]
					return
				end
				prompt.markup = input
				user[var] = input
				awful.spawn.easy_async_with_shell([[ sed -i -e "s/user.]] ..var.. [[ =.*/user.]] ..var.. [[ = ']] ..input.. [['/g" ]] ..user_file)
			end
		})
	end

	local text = wibox.widget {
		widget = wibox.widget.textbox,
		text = name
	}

	local widget = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		spacing = 10,
		text,
		{
			widget = wibox.container.background,
			border_width = beautiful.border_width,
			border_color = beautiful.border_color_normal,
			forced_height = 40,
			forced_width = 430,
			{
				widget = wibox.container.margin,
				margins = { right = 10, left = 10 },
				prompt
			}
		}
	}
	widget:buttons {
		awful.button(nil, 1, function()
			get_input()
		end)
	}

	return widget
end

return create_passbox
