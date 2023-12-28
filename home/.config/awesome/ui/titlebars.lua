local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local rubato = require("modules.rubato")
local user = require("user")
local helpers = require("helpers")

local Titlebar = {}

function Titlebar.create_button_v(c, color, name, func)
	local widget = wibox.widget {
		widget = wibox.container.background,
		forced_width = 22,
		forced_height = 24,
		buttons = {
			awful.button({}, 1, function()
				func()
			end)
		}
	}
	local popup = awful.tooltip {
		objects = { widget },
		timer_function = function()
			return name
		end,
		mode = "outside",
		gaps = beautiful.useless_gap,
		margins_leftright = 10,
		margins_topbottom = 10,
		delay_show = 1.5
	}

	local widget_anim = rubato.timed {
		duration = 0.3,
		easing = rubato.easing.linear,
		subscribed = function(h)
			widget.forced_height = h
		end
	}
	widget_anim.target = 24

	widget:connect_signal("mouse::enter", function()
		widget_anim.target = 38
	end)
	widget:connect_signal("mouse::leave", function()
		widget_anim.target = 24
	end)

	c:connect_signal("property::active", function(c)
		if c.active then
			helpers.ui.transitionColor {
				old = beautiful.bg_alt,
				new = color,
				transformer = function(col)
					widget:set_bg(col)
				end,
				duration = 0.8
			}
		else
			helpers.ui.transitionColor {
				old = color,
				new = beautiful.bg_alt,
				transformer = function(col)
					widget:set_bg(col)
				end,
				duration = 0.8
			}
		end
	end)

	return widget
end

function Titlebar.create_button_h(c, color, name, func)
	local widget = wibox.widget {
		widget = wibox.container.background,
		forced_width = 24,
		forced_height = 22,
		bg = color,
		buttons = {
			awful.button({}, 1, function()
				func()
			end)
		}
	}
	local popup = awful.tooltip {
		objects = { widget },
		timer_function = function()
			return name
		end,
		mode = "outside",
		gaps = beautiful.useless_gap,
		margins_leftright = 10,
		margins_topbottom = 10,
		delay_show = 1.5
	}

	local widget_anim = rubato.timed {
		duration = 0.3,
		easing = rubato.easing.linear,
		subscribed = function(h)
			widget.forced_width = h
		end
	}
	widget_anim.target = 24

	widget:connect_signal("mouse::enter", function()
		widget_anim.target = 38
	end)
	widget:connect_signal("mouse::leave", function()
		widget_anim.target = 24
	end)

	c:connect_signal("property::active", function(c)
		if c.active then
			helpers.ui.transitionColor {
				old = beautiful.bg_alt,
				new = color,
				transformer = function(col)
					widget:set_bg(col)
				end,
				duration = 0.8
			}
		else
			helpers.ui.transitionColor {
				old = color,
				new = beautiful.bg_alt,
				transformer = function(col)
					widget:set_bg(col)
				end,
				duration = 0.8
			}
		end
	end)

	return widget
end

function Titlebar:create_titlebar(c, pos)

	Titlebar.buttons = gears.table.join(
	awful.button({ }, 1, function()
		client.focus = c
		c:raise()
		awful.mouse.client.move(c)
	end),
	awful.button({ }, 3, function()
		client.focus = c
		c:raise()
		awful.mouse.client.resize(c)
	end)
	)

	if pos == "Left" or pos == "Right" then

		Titlebar.minimize = Titlebar.create_button_v(c, beautiful.yellow, "minimize",
		function()
			gears.timer.delayed_call(function()
				c.minimized = not c.minimized
			end)
		end
		)

		Titlebar.maximize = Titlebar.create_button_v(c, beautiful.green, "maximize",
		function()
			c.maximized = not c.maximized
		end
		)

		Titlebar.close = Titlebar.create_button_v(c, beautiful.red, "kill",
		function ()
			c:kill()
		end
		)

		Titlebar.bar = awful.titlebar(c, {
			size = 36,
			position = user.titlebar_pos:lower()
		}):setup {
			layout = wibox.layout.align.vertical,
			{
				widget = wibox.container.place,
				valign = "top",
				{
					widget = wibox.container.margin,
					margins = { right = 12, left = 12, top = 12 },
					{
						layout = wibox.layout.fixed.vertical,
						spacing = 8,
						Titlebar.maximize,
						Titlebar.minimize,
						Titlebar.close,
					}
				}
			},
			{
				widget = wibox.container.background,
				buttons = Titlebar.buttons,
			},
			{
				widget = wibox.container.background,
				buttons = Titlebar.buttons
			}
		}

	elseif pos == "Top" or pos == "Bottom" then

		Titlebar.minimize = Titlebar.create_button_h(c, beautiful.yellow, "minimize",
		function()
			gears.timer.delayed_call(function()
				c.minimized = not c.minimized
			end)
		end
		)

		Titlebar.maximize = Titlebar.create_button_h(c, beautiful.green, "maximize",
		function()
			c.maximized = not c.maximized
		end
		)

		Titlebar.close = Titlebar.create_button_h(c, beautiful.red, "kill",
		function ()
			c:kill()
		end
		)

		Titlebar.bar = awful.titlebar(c, {
			size = 36,
			position = user.titlebar_pos:lower()
		}):setup {
			layout = wibox.layout.align.horizontal,
			{
				widget = wibox.container.margin,
				margins = { left = 12, bottom = 12, top = 12 },
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = 8,
					Titlebar.maximize,
					Titlebar.minimize,
					Titlebar.close,
				}
			},
			{
				widget = wibox.container.background,
				buttons = Titlebar.buttons,
			},
			{
				widget = wibox.container.background,
				buttons = Titlebar.buttons
			}
		}

	end

end

return Titlebar
