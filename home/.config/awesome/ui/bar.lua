local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local user = require("user")
local rubato = require("modules.rubato")

local Launcher = require("ui.launcher")
local Control = require("ui.control")

local Bar = {}

function Bar:create_container(args)
	local box = wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		{
			widget = wibox.container.margin,
			margins = args.margins,
			args.widget
		}
	}
	return box
end

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

-- launcher --

Bar.launcher = wibox.widget {
	widget = wibox.widget.textbox,
	text = "",
	halign = "center",
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 1)
}

Bar.launcher_v = Bar:create_container({
	widget = Bar.launcher,
	margins = { top = 8, bottom = 8 }
})

Bar.launcher_h = Bar:create_container({
	widget = Bar.launcher,
	margins = { right = 8, left = 8 }
})

Bar.launcher:buttons {
	awful.button({}, 1, function()
		Launcher:toggle()
	end)
}

-- keyboard layout --

Bar.mykeyboard = awful.widget.keyboardlayout()
Bar.mykeyboard.widget.text = string.upper(Bar.mykeyboard.widget.text)
Bar.mykeyboard.widget.halign = "center"
Bar.mykeyboard.widget:connect_signal("widget::redraw_needed", function(wid)
	wid.text = string.upper(wid.text)
end)

Bar.keyboard_v = Bar:create_container({
	widget = Bar.mykeyboard,
	margins = { top = 8, bottom = 8, left = -4, right = -4 }

})
Bar.keyboard_h = Bar:create_container({
	widget = Bar.mykeyboard,
	margins = { left = -4, right = -4 },
})

-- tray --

Bar.tray_widget = wibox.widget {
	state = false,
	widget = wibox.container.constraint,
	strategy = "max",
	height = 0,
	{
		widget = wibox.container.margin,
		margins = { top = 8, bottom = 8 },
		{
			widget = wibox.widget.systray,
			horizontal = false,
			base_size = 24
		}
	}
}

Bar.tray_button = wibox.widget {
	widget = wibox.widget.textbox,
	text = "",
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 5),
	halign = "center",
}

Bar.tray_v = Bar:create_container({
	widget = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		{
			widget = wibox.container.margin,
			margins = 2,
			Bar.tray_button
		},
		{
			widget = wibox.container.place,
			halign = "center",
			Bar.tray_widget
		}
	}
})

Bar.tray_h = wibox.widget {
	widget = wibox.container.rotate,
	direction = "east",
	Bar.tray_v
}

function Bar:tray_toggle()
	if not self.tray_widget.state then
		self.tray_button.text = ""
		Bar.tray_widget.height = 200
	else
		self.tray_button.text = ""
		Bar.tray_widget.height = 0
	end
	self.tray_widget.state = not self.tray_widget.state
end

Bar.tray_v:buttons{
	awful.button({}, 1, function()
		Bar:tray_toggle()
	end)
}

-- clock --

Bar.time_v = Bar:create_container({
	widget = wibox.widget {
		widget = wibox.widget.textclock,
		format = "%H\n%M\n%S",
		refresh = 1,
		halign = "center"
	},
	margins = { top = 6, bottom = 6 }
})

Bar.time_h = Bar:create_container({
	widget = wibox.widget {
		widget = wibox.widget.textclock,
		format = "%H:%M:%S",
		refresh = 1,
		halign = "center"
	},
	margins = { left = 8, right = 8 },
})

Bar.time_button = gears.table.join (
awful.button({}, 1, function()
	Control:toggle("moment")
end)
)
Bar.time_v:buttons { Bar.time_button }
Bar.time_h:buttons { Bar.time_button }

-- taglist --

function Bar:create_taglist(s)

	self.taglist = awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({ }, 1, function(t) t:view_only() end),
			awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
			awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
		},
		layout = {
			spacing = 10,
			layout = wibox.layout.fixed.vertical
		},
		widget_template = {
			id = "background_role",
			forced_height = 20,
			widget = wibox.container.background,
			create_callback = function(self, tag)
				self.animate = rubato.timed {
					duration = 0.3,
					easing = rubato.easing.linear,
					subscribed = function(h)
						self:get_children_by_id("background_role")[1].forced_height = h
					end
				}
				self.update = function()
					if tag.selected then
						self.animate.target = 32
					elseif #tag:clients() > 0 then
						self.animate.target = 20
					else
						self.animate.target = 20
					end
				end
				self.update()
			end,
			update_callback = function(self)
				self.update()
			end,
		},
	}

	self.taglist_widget = wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		{
			widget = wibox.container.margin,
			margins = 14,
			Bar.taglist
		}
	}

	return self.taglist_widget

end

-- battery --

Bar.battery_progressbar = wibox.widget {
	widget = wibox.widget.progressbar,
	max_value = 100,
	forced_width = 80,
	background_color = beautiful.bg_urgent,
}

Bar.battery_charge_icon = wibox.widget {
	widget = wibox.widget.textbox,
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 11),
	halign = "center",
	valign = "center"
}

Bar.battery_v = wibox.widget {
	layout = wibox.layout.stack,
	{
		widget = wibox.container.rotate,
		direction = "east",
		Bar.battery_progressbar
	},
	Bar.battery_charge_icon
}

Bar.battery_h = wibox.widget {
	layout = wibox.layout.stack,
	Bar.battery_progressbar,
	Bar.battery_charge_icon
}

awesome.connect_signal("signal::battery", function(value, state)
	Bar.battery_progressbar.value = value
	if value > 70 then
		Bar.battery_progressbar.color = beautiful.green
	elseif value > 20 then
		Bar.battery_progressbar.color = beautiful.yellow
	else
		Bar.battery_progressbar.color = beautiful.red
	end
	if state == "Discharging" then
		Bar.battery_charge_icon.markup = ""
	else
		Bar.battery_progressbar.color = beautiful.green
		if value < 45 then
			Bar.battery_charge_icon.markup = helpers.ui.colorizeText("󱐋", beautiful.fg_alt)
		else
			Bar.battery_charge_icon.markup = helpers.ui.colorizeText("󱐋", beautiful.bg)
		end
	end
end)

-- info --

Bar.info_volume = wibox.widget {
	widget = wibox.widget.textbox,
	halign = "center",
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 1)
}

Bar.info_wifi = wibox.widget {
	widget = wibox.widget.textbox,
	halign = "center",
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 1)
}

Bar.info_dnd = wibox.widget {
	widget = wibox.container.background,
	fg = beautiful.fg,
	{
		widget = wibox.widget.textbox,
		text = "",
		halign = "center",
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 1)
	}
}

Bar.bluetooth = wibox.widget {
	widget = wibox.container.background,
	fg = beautiful.fg,
	{
		widget = wibox.widget.textbox,
		text = "",
		halign = "center",
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 1)
	}
}

Bar.info_v = Bar:create_container({
	widget = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		spacing = 10,
		Bar.bluetooth,
		Bar.info_wifi,
		Bar.info_dnd
	},
	margins = { top = 8, bottom = 8 }
})

Bar.info_h = Bar:create_container({
	widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 10,
		Bar.bluetooth,
		Bar.info_wifi,
		Bar.info_dnd
	},
	margins = { left = 8, right = 8 },
})

Bar.info_button = gears.table.join(
awful.button({}, 1, function()
	Control:toggle("main")
end)
)
Bar.info_v:buttons { Bar.info_button }
Bar.info_h:buttons { Bar.info_button }

awesome.connect_signal("signal::volume", function(value, icon)
	Bar.info_volume.text = icon
end)

awesome.connect_signal("signal::bluetooth", function(value)
	if value then
		Bar.bluetooth:set_fg(beautiful.fg)
	else
		Bar.bluetooth:set_fg(beautiful.fg_alt)
	end
end)

awesome.connect_signal("wifi:status", function(value)
	if not value then
		Bar.info_wifi.text = ""
	else
		Bar.info_wifi.text = ""
	end
end)

function Bar:dnd_toggle()
	if not naughty.is_suspended() then
		Bar.info_dnd:set_fg(beautiful.fg_alt)
		naughty.suspend()
	else
		Bar.info_dnd:set_fg(beautiful.fg)
		naughty.resume()
	end
end

-- layouts --

Bar.layouts = Bar:create_container({
	widget = wibox.widget {
		widget = wibox.container.margin,
		margins = 5,
		awful.widget.layoutbox {
			buttons = {
				awful.button({ }, 1, function() awful.layout.inc(1) end)
			}
		}
	}
})

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
				Bar.launcher_v,
				Bar.time_v,
				self:create_taglist(s)
			},
			nil,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 8,
				Bar.tray_v,
				Bar.info_v,
				Bar.keyboard_v,
				Bar.battery_v,
				Bar.layouts,
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
				Bar.launcher_h,
				Bar.time_h,
				{
					widget = wibox.container.rotate,
					direction = "east",
					self:create_taglist(s)
				}
			},
			nil,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 8,
				Bar.tray_h,
				Bar.info_h,
				Bar.keyboard_h,
				Bar.battery_h,
				Bar.layouts,
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
