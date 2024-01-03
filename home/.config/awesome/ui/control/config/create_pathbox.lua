local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local user = require("user")
local helpers = require("helpers")
local user_file = "~/.config/awesome/user.lua"
local naughty = require("naughty")

local function create_pathbox(var, name)

	local prompt = wibox.widget {
		widget = wibox.widget.textbox,
		markup = user[var]
	}

	local text = wibox.widget {
		widget = wibox.widget.textbox,
		text = name
	}

	local button = wibox.widget {
		widget = wibox.container.background,
		forced_height = 30,
		forced_width = 30,
		{
			widget = wibox.widget.textbox,
			text = "",
			font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 3),
		}
	}
	button:buttons {
		awful.button({}, 1, function()
			awful.spawn.easy_async_with_shell("zenity --file-selection --filename ~/", function(stdout, stderr, reason, code)
				if reason == "exit" then
					if stdout ~= "" then
						local write = stdout:gsub([[/]], [[\/]])
						prompt.markup = stdout
						awful.spawn.easy_async_with_shell([[sed -i -e "s/user.]] ..var.. [[ =.*/user.]] ..var.. [[ = ']] ..write.. [['/g" ]] .. user_file)
					end
				end
			end)
		end)
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
				{
					layout = wibox.layout.align.horizontal,
					prompt,
					nil,
					button
				}
			}
		}
	}

	return widget
end

return create_pathbox
