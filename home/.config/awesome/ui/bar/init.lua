local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local user = require("user")

local launcher = require("ui.bar.modules.launcher")
local keyboard = require("ui.bar.modules.keyboard")
local tray = require("ui.bar.modules.tray")
local clock = require("ui.bar.modules.clock")
local battery = require("ui.bar.modules.battery")
local info = require("ui.bar.modules.info")
local layouts = require("ui.bar.modules.layouts")
local taglist = require("ui.bar.modules.taglist")

local Bar = {}

function Bar:change_bg_container(widget, x)
	if x == "on" then
		helpers.ui.transitionColor {
			old = beautiful.bg_alt,
			new = beautiful.bg_urgent,
			transformer = function(col)
				widget:set_bg(col)
			end,
			duration = 0.8
		}
	else
		helpers.ui.transitionColor {
			old = beautiful.bg_urgent,
			new = beautiful.bg_alt,
			transformer = function(col)
				widget:set_bg(col)
			end,
			duration = 0.8
		}
	end
end

awesome.connect_signal("bar::info", function(x)
	Bar:change_bg_container(info.widget, x)
end)

-- bar --

function Bar:create_bar_v(s, pos, margins)

	self.main_widget = wibox.widget {
		widget = wibox.container.margin,
		margins = 8,
		{
			layout = wibox.layout.align.vertical,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 8,
				launcher:create_v(),
				clock:create_v(),
				taglist:create_v(s)
			},
			nil,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 8,
				tray:create_v(),
				info:create_v(),
				keyboard:create_v(),
				battery:create_v(),
				layouts:create()
			}
		}
	}

	self.wibar = awful.wibar {
		screen = s,
		position = pos,
		ontop = false,
		height = s.geometry.height,
		width = user.bar_size + beautiful.border_width,
		widget = wibox.widget {
			widget = wibox.container.background,
			bg = beautiful.border_color_normal,
			{
				widget = wibox.container.margin,
				margins = margins,
				{
					widget = wibox.container.background,
					bg = beautiful.bg,
					self.main_widget
				}
			}
		}
	}

	if user.bar_float then
		if user.bar_pos == "Left" or user.bar_pos == "Right" then
			self.wibar.width = user.bar_size + beautiful.border_width * 2
			self.wibar.height = s.geometry.height - beautiful.useless_gap * 4
		end
		if user.bar_pos == "Left" then
			self.wibar.margins = {
				left = beautiful.useless_gap * 2,
				bottom = beautiful.useless_gap * 2,
				top = beautiful.useless_gap * 2
			}
		elseif user.bar_pos == "Right" then
			self.wibar.margins = {
				right = beautiful.useless_gap * 2,
				bottom = beautiful.useless_gap * 2,
				top = beautiful.useless_gap * 2
			}
		end
	end

	return self.wibar

end

function Bar:create_bar_h(s, pos, margins)

	self.main_widget = wibox.widget {
		widget = wibox.container.margin,
		margins = 8,
		{
			layout = wibox.layout.align.horizontal,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 8,
				launcher:create_h(),
				clock:create_h(),
				taglist:create_h(s),
			},
			nil,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 8,
				tray:create_h(),
				info:create_h(),
				keyboard:create_h(),
				battery:create_h(),
				layouts:create()
			}
		}
	}

	self.wibar = awful.wibar {
		screen = s,
		position = pos,
		ontop = false,
		width = s.geometry.width,
		height = user.bar_size + beautiful.border_width,
		widget = wibox.widget {
			widget = wibox.container.background,
			bg = beautiful.border_color_normal,
			{
				widget = wibox.container.margin,
				margins = margins,
				{
					widget = wibox.container.background,
					bg = beautiful.bg,
					self.main_widget
				}
			}
		}
	}

	if user.bar_float then
		if user.bar_pos == "Top" or user.bar_pos == "Bottom" then
			self.wibar.width = s.geometry.width - beautiful.useless_gap * 4
			self.wibar.height = user.bar_size + beautiful.border_width * 2
		end
		if user.bar_pos == "Bottom" then
			self.wibar.margins = {
				left = beautiful.useless_gap * 2,
				right = beautiful.useless_gap * 2,
				bottom = beautiful.useless_gap * 2
			}
		elseif user.bar_pos == "Top" then
			self.wibar.margins = {
				left = beautiful.useless_gap * 2,
				right = beautiful.useless_gap * 2,
				top = beautiful.useless_gap * 2
			}
		end
	end

	return self.wibar
end

function Bar:toggle()
	self.wibar.visible = not self.wibar.visible
end

return Bar
