local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local user = require("user")
local helpers = require("helpers")
local user_file = "~/.config/awesome/user.lua"

local function create_dropmenu(var, name, list)

	local text = wibox.widget {
		widget = wibox.widget.textbox,
		text = name
	}

	local button_text = wibox.widget {
		widget = wibox.widget.textbox,
		text = user[var]
	}

	local list_layout = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		spacing = 10
	}

	local popup = awful.popup {
		ontop = true,
		visible = false,
		bg = beautiful.bg_alt,
		border_width = beautiful.border_width,
		border_color = beautiful.border_color_normal,
		minimum_width = 100,
		maximum_width = 200,
		minimum_height = 80,
		maximum_height = 300,
		widget = wibox.widget {
			widget = wibox.container.margin,
			margins = 10,
			list_layout
		}
	}

	for _, el in ipairs(list) do
		local el_widget = wibox.widget {
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			forced_height = 30,
			buttons = {
				awful.button({}, 1, function()
					button_text.text = el
					popup.visible = false
					local command = [[ sed -i -e "s/user.]] ..var.. [[ =.*/user.]] ..var.. [[ = ']] ..el.. [['/g" ]] ..user_file
					awful.spawn.easy_async_with_shell(command, function(stdout, stderr, reason, code)
						if reason == "exit" then
							awesome.emit_signal("droplist::change", var, el)
						end
					end)
				end)
			},
			{
				widget = wibox.container.margin,
				margins = { right = 10, left = 10 },
				{
					widget = wibox.widget.textbox,
					text = el
				}
			}
		}
		list_layout:add(el_widget)
	end

	local button = wibox.widget {
		widget = wibox.container.background,
		forced_width = 200,
		border_width = beautiful.border_width,
		border_color = beautiful.bg_urgent,
		buttons = {
			awful.button({}, 1, function()
				if popup.visible then
					popup.visible = false
				else
					popup.x = mouse.coords().x - 40
					popup.y = mouse.coords().y + 40
					popup.visible = true
				end
			end)
		},
		{
			widget = wibox.container.margin,
			margins = { left = 10, right = 10 },
			{
				layout = wibox.layout.align.horizontal,
				button_text,
				nil,
				{
					widget = wibox.widget.textbox,
					text = "",
				}
			}
		}
	}

	local widget = wibox.widget {
		layout = wibox.layout.align.horizontal,
		forced_height = 40,
		text,
		nil,
		button
	}

	return widget
end

return create_dropmenu
