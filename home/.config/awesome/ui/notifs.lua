local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
local rubato = require("modules.rubato")
local helpers = require("helpers")
local user = require("user")

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification {
		urgency = "critical",
		title = "Oops, an error happened"..(startup and " during startup!" or "!"),
		message = message,
		icon = beautiful.notification_icon_error,
	}
end)

ruled.notification.connect_signal('request::rules', function()

	ruled.notification.append_rule {
		rule = { urgency = "normal" },
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 4,
			position = user.notifs_pos,
			spacing = beautiful.useless_gap * 2,
			bg = beautiful.bg,
			fg = beautiful.fg,
			border_width = beautiful.border_width,
			border_color = beautiful.border_color_normal,
		}
	}

	ruled.notification.append_rule {
		rule = { urgency = "critical" },
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 4,
			position = user.notifs_pos,
			spacing = beautiful.useless_gap * 2,
			bg = beautiful.bg,
			fg = beautiful.fg,
			border_width = beautiful.border_width,
			border_color = beautiful.border_color_normal,
			icon = beautiful.notification_error,
		}
	}

end)

naughty.connect_signal("request::display", function(n)

	if not n.app_icon then
		n.app_icon = beautiful.notification_icon
	elseif n.app_name == "flameshot" then
		n.app_icon = beautiful.notification_icon_screenshot
	end

	naughty.layout.box {
		notification = n,
		minimum_width = 200,
		maximum_width = 800,
		maximum_height = 200,
		widget_template = {
			widget = wibox.container.constraint,
			strategy = "max",
			{
				widget = naughty.container.background,
				id = "background_role",
				{
					layout = wibox.layout.fixed.vertical,
					{
						widget = wibox.container.background,
						bg = beautiful.bg,
						forced_height = 40,
						{
							widget = wibox.container.margin,
							margins = { left = 8, right = 8 },
							{
								layout = wibox.layout.align.horizontal,
								{
									widget = wibox.widget.textbox,
									valign = "center",
									markup = n.title
								},
								nil,
								{
									widget = wibox.widget.textbox,
									valign = "center",
									markup = helpers.ui.colorizeText("", beautiful.red)
								}
							}
						}
					},
					{
						widget = wibox.container.margin,
						margins = {  bottom = 8 },
						{
							widget = wibox.container.background,
							bg = beautiful.bg_alt,
							forced_height = beautiful.border_width,
						},
					},
					{
						widget = wibox.container.margin,
						margins = { left = 8, right = 8, bottom = 8 },
						{
							layout = wibox.layout.fixed.horizontal,
							spacing = 20,
							fill_space = true,
							{
								widget = wibox.container.background,
								naughty.widget.icon,
							},
							{
								widget = wibox.widget.textbox,
								markup = n.message,
							}
						}
					}
				}
			}
		}
	}

end)
