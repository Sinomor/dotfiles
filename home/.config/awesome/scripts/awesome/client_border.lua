local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local rubato = require("modules.rubato")

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
