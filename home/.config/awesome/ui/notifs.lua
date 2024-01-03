local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
local rubato = require("modules.rubato")
local helpers = require("helpers")
local user = require("user")

local pos = {
	["Top Left"] = "top_left",
	["Top Right"] = "top_right",
	["Top Center"] = "top_middle",
	["Bottom Left"] = "bottom_left",
	["Bottom Right"] = "bottom_right",
	["Bottom Center"] = "bottom_middle"
}

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
			position = pos[user.notifs_pos],
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
			position = pos[user.notifs_pos],
			spacing = beautiful.useless_gap * 2,
			bg = beautiful.bg,
			fg = beautiful.red,
			border_width = beautiful.border_width,
			border_color = beautiful.border_color_normal,
			icon = beautiful.notification_error,
		}
	}

end)

naughty.connect_signal("request::display", function(n)

	local appicon = n.icon or n.app_icon
	if not appicon then
		appicon = beautiful.notification_icon
	elseif n.app_name == "flameshot" then
		appicon = beautiful.notification_icon_screenshot
	end

	local icon = wibox.widget {
		widget = wibox.widget.imagebox,
		image = appicon,
		halign = "center",
		valign = "top",
	}

	if n.app_name == "AyuGram Desktop" or n.app_name == "Telegram Desktop" then
		icon.clip_shape = helpers.ui.rrect(100)
	end

	local title = wibox.widget {
		widget = wibox.widget.textbox,
		halign = "left",
		valign = "center",
		forced_height = 20,
		markup = n.title
	}

	local text = wibox.widget {
		widget = wibox.widget.textbox,
		valign = "top",
		halign = "left",
		markup = n.message or n.text,
	}
	if n.urgency == "critical" then
		text.markup = helpers.ui.colorizeText(n.message or n.text, beautiful.red)
	end

	naughty.layout.box {
		notification = n,
		minimum_width = 300,
		maximum_width = 300,
		maximum_height = 120,
		minimum_height = 120,
		widget_template = {
			widget = naughty.container.background,
			id = "background_role",
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 10,
				{
					widget = wibox.container.margin,
					margins = { left = 10, right = 10, top = 10 },
					title,
				},
				{
					widget = wibox.container.background,
					bg = beautiful.bg_alt,
					forced_height = beautiful.border_width,
				},
				{
					widget = wibox.container.margin,
					margins = { left = 10, right = 10, bottom = 10 },
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = 20,
						icon,
						text
					}
				}
			}
		}
	}

end)
