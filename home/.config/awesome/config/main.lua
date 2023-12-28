local user = require("user")
local awful = require("awful")
local beautiful = require("beautiful")
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
