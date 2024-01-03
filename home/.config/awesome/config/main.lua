local user = require("user")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
require("awful.autofocus")

local Bar = require("ui.bar")
local Titlebar = require("ui.titlebars")

awful.screen.connect_for_each_screen(function(s)
	if not user.bar_float then
		if user.bar_pos == "Bottom" then
			Bar:create_bar_h(s, "bottom", { top = beautiful.border_width })
		elseif user.bar_pos == "Top" then
			Bar:create_bar_h(s, "top", { bottom = beautiful.border_width })
		elseif user.bar_pos == "Left" then
			Bar:create_bar_v(s, "left", { right = beautiful.border_width })
		elseif user.bar_pos == "Right" then
			Bar:create_bar_v(s, "right", { left = beautiful.border_width })
		end
	else
		if user.bar_pos == "Bottom" then
			Bar:create_bar_h(s, "bottom", beautiful.border_width)
		elseif user.bar_pos == "Top" then
			Bar:create_bar_h(s, "top", beautiful.border_width)
		elseif user.bar_pos == "Left" then
			Bar:create_bar_v(s, "left", beautiful.border_width)
		elseif user.bar_pos == "Right" then
			Bar:create_bar_v(s, "right", beautiful.border_width)
		end
	end
end)

client.connect_signal("request::titlebars", function(c)
	Titlebar:create_titlebar(c, user.titlebar_pos)
end)

client.connect_signal("property::active", function(c)
	if c.active then
		helpers.ui.transitionColor {
			old = beautiful.border_color_normal,
			new = beautiful.border_color_active,
			transformer = function(col)
				local valid = pcall(function() return c.valid end) and c.valid
				if not valid then return end
				c.border_color = col
			end,
			duration = 0.8
		}
	else
		helpers.ui.transitionColor {
			old = beautiful.border_color_active,
			new = beautiful.border_color_normal,
			transformer = function(col)
				local valid = pcall(function() return c.valid end) and c.valid
				if not valid then return end
				c.border_color = col
			end,
			duration = 0.8
		}
	end
end)

client.connect_signal("request::manage", function(c)
	if c.maximized then
		c.x = c.screen.workarea.x
		c.y = c.screen.workarea.y
		c.width = c.screen.workarea.width
		c.height = c.screen.workarea.height
	elseif c.fullscreen then
		c.x = c.screen.geometry.x
		c.y = c.screen.geometry.y
		c.width = c.screen.geometry.width
		c.height = c.screen.geometry.height
	end
end)
