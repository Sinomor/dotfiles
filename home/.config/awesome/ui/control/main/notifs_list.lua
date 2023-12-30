local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local helpers = require("helpers")
local beautiful = require("beautiful")
local rubato = require("modules.rubato")
local user = require("user")

local Notifs_list = {}

Notifs_list.label = wibox.widget {
	text = "Notifications",
	halign = "center",
	valign = "center",
	widget = wibox.widget.textbox,
}

Notifs_list.count_widget = wibox.widget.textbox()

Notifs_list.clear = wibox.widget {
	markup = helpers.ui.colorizeText("", beautiful.red),
	halign = "center",
	valign = "center",
	widget = wibox.widget.textbox,
	buttons = {
		awful.button({}, 1, function()
			Notifs_list:reset_notifs()
			Notifs_list.count_widget.text = ""
		end)
	}
}

Notifs_list.empty_container = wibox.widget {
	forced_height = 300,
	forced_width = 470,
	widget = wibox.container.background,
	{
		layout = wibox.layout.flex.vertical,
		{
			markup = helpers.ui.colorizeText("No notifications", beautiful.fg_alt),
			align = "center",
			valign = "center",
			widget = wibox.widget.textbox,
		},
	},
}

Notifs_list.container = wibox.widget {
	forced_width = 470,
	layout = wibox.layout.overflow.vertical,
	scrollbar_enabled = false,
	spacing = 10,
	step = 80,
}
if not user.control_fullscreen then
	Notifs_list.container.forced_height = 420
end

Notifs_list.remove_notifs_empty = true

function Notifs_list:reset_notifs()
	self.container:reset(self.container)
	self.container:insert(1, self.empty_container)
	self.remove_notifs_empty = true
end

function Notifs_list:remove_notif(box)
	self.container:remove_widgets(box)
	if #self.container.children == 0 then
		self.container:insert(1, self.empty_container)
		self.remove_notifs_empty = true
	end
end

function Notifs_list:create_notif(icon, n, width)

	local time = os.date "%H:%M:%S"

	local n_icon = wibox.widget {
		widget = wibox.widget.imagebox,
		forced_width = 80,
		forced_height = 80,
		image = icon,
		halign = "center",
		valign = "top",
	}

	local n_title = wibox.widget {
		widget = wibox.widget.textbox,
		markup = n.title,
		halign = "left",
	}

	local n_time = {
		widget = wibox.widget.textbox,
		text = time,
		align = "right",
	}

	local n_text = wibox.widget {
		markup = n.message or n.text,
		halign = "left",
		valign = "top",
		widget = wibox.widget.textbox,
	}

	local time_arroy = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 10,
		n_time,
	}

	local icon_text = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 20,
		n_icon,
		n_text
	}


	local title_layout = wibox.widget {
		layout = wibox.layout.align.horizontal,
		{
			widget = wibox.container.scroll.horizontal,
			step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
			speed = 50,
			forced_width = 300,
			n_title,
		},
		nil,
		time_arroy
	}

	local box_arroy = false

	local box = wibox.widget {
		widget = wibox.container.constraint,
		height = 150,
		strategy = "max",
		{
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			{
				widget = wibox.container.margin,
				margins = 10,
				{
					widget = wibox.layout.fixed.vertical,
					spacing = 10,
					title_layout,
					{
						widget = wibox.container.background,
						bg = beautiful.bg_urgent,
						forced_height = beautiful.border_width
					},
					icon_text
				}
			}
		}
	}

	if n.app_name == "AyuGram Desktop" or n.app_name == "Telegram Desktop" then
		n_icon.clip_shape = helpers.ui.rrect(100)
	end

	local anim = rubato.timed {
		duration = 0.3,
		easing = rubato.easing.linear,
		subscribed = function(h)
			box.height = h
		end
	}

	anim.target = 150

	local arroy_icon = wibox.widget {
		widget = wibox.widget.textbox,
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 3),
		text = ""
	}

	local arroy = wibox.widget {
		widget = wibox.container.background,
		{
			widget = wibox.container.margin,
			margins = { left = 4, right = 4 },
			arroy_icon
		}
	}

	arroy:connect_signal("mouse::enter", function()
		helpers.ui.transitionColor {
			old = beautiful.bg_alt,
			new = beautiful.bg_urgent,
			transformer = function(col)
				arroy:set_bg(col)
			end,
			duration = 0.8
		}
	end)
	arroy:connect_signal("mouse::leave", function()
		helpers.ui.transitionColor {
			old = beautiful.bg_urgent,
			new = beautiful.bg_alt,
			transformer = function(col)
				arroy:set_bg(col)
			end,
			duration = 0.8
		}
	end)


	if string.len(n.message) > 90 then
		time_arroy:insert(2, arroy)
	end

	arroy:buttons {
		awful.button({}, 1, function()
			if not box_arroy then
				anim.target = 500
				arroy_icon.text = ""
			else
				anim.target = 150
				arroy_icon.text = ""
			end
			box_arroy = not box_arroy
		end)
	}

	box:buttons {
		awful.button({}, 3, function()
			self:remove_notif(box)
			if self.remove_notifs_empty then
				self.count_widget.text = ""
			else
				self.count_widget.text = "(" .. #self.container.children .. ")"
			end
		end)
	}

	return box
end

Notifs_list.container:insert(1, Notifs_list.empty_container)

naughty.connect_signal("request::display", function(n)
	if #Notifs_list.container.children == 1 and Notifs_list.remove_notifs_empty then
		Notifs_list.container:reset()
		Notifs_list.remove_notifs_empty = false
	end

	local appicon = n.icon or n.app_icon
	if not appicon then
		appicon = beautiful.notification_icon
	end
	if n.app_name == "flameshot" then
		appicon = beautiful.notification_icon_screenshot
	end

	Notifs_list.container:insert(1, Notifs_list:create_notif(appicon, n))
	Notifs_list.count_widget.text = "(" .. #Notifs_list.container.children .. ")"
end)

Notifs_list.header = wibox.widget {
	layout = wibox.layout.align.horizontal,
	forced_height = 40,
	{
		layout = wibox.layout.fixed.horizontal,
		spacing = 10,
		Notifs_list.label,
		Notifs_list.count_widget
	},
	nil,
	Notifs_list.clear
}

Notifs_list.main_widget = wibox.widget {
	layout = wibox.layout.stack,
	{
		spacing = 10,
		layout = wibox.layout.fixed.vertical,
		Notifs_list.header,
		Notifs_list.container,
	},
}

return Notifs_list
