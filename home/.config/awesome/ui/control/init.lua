local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local user = require("user")

local Top = require("daemons.processes")

local System = require("ui.control.system")
local Moment = require("ui.control.moment")
local Main = require("ui.control.main")
local Config = require("ui.control.config")
local Calendar = require("ui.control.moment.calendar")

local Tabbar = {}
local Control = {}

-- bar modules --

local Bar = require("ui.bar")
local Clock = require("ui.bar.mods.clock")
local Info = require("ui.bar.mods.info")

Clock.widget:buttons {
	awful.button({}, 1, function()
		Control:toggle("moment")
	end)
}
Info.widget:buttons {
	awful.button({}, 1, function()
		Control:toggle("main")
	end)
}

-- main --


Tabbar.main_layout = wibox.widget {
	layout = user.control_fullscreen and wibox.layout.fixed.horizontal or wibox.layout.fixed.vertical,
	spacing = 10,
}

Tabbar.main_widget = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.bg_alt,
	{
		widget = wibox.container.margin,
		margins = 10,
		Tabbar.main_layout
	}
}
if user.control_fullscreen then
	Tabbar.main_widget.forced_width = 470
else
	Tabbar.main_widget.forced_height = 60
end

Tabbar.tabs = {
	{ name = "main", icon = "", to = Main.main_widget },
	{ name = "moment", icon = "", to = Moment.main_widget },
	{ name = "system", icon = "", to = System.main_widget },
	{ name = "config", icon = "", to = Config.main_widget }
}

function Tabbar:tab_change(mode)
	self.main_layout:reset()
	Control.main_layout:reset()
	Control:open(mode)
end

function Tabbar:toggle_timers(x)
	if x then
		Top:gen_top_list()
		Top.timer:start()
	else
		Top.timer:stop()
	end
end

function Tabbar:add_tabs()
	self.main_layout:reset()

	for i, tab in ipairs(self.tabs) do
		local tab_widget = wibox.widget {
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			forced_width = 40,
			forced_height = 40,
			buttons = {
				awful.button({}, 1, function()
					if self.index_tab ~= i then
						self:tab_change(tab.name)
					end
				end),
			},
			{
				widget = wibox.widget.textbox,
				fg = beautiful.fg,
				halign = "center",
				font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 3),
				markup = tab.icon
			}
		}

		self.main_layout:add(tab_widget)

		if i == self.index_tab then
			helpers.ui.transitionColor {
				old = beautiful.bg_alt,
				new = beautiful.bg_urgent,
				transformer = function(col)
					tab_widget.bg = col
				end,
				duration = 0.8
			}
		end
	end
end

Control.main_layout = wibox.widget {
	layout = user.control_fullscreen and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal,
	spacing = 10
}

Control.main_widget = wibox.widget {
	widget = wibox.container.margin,
	margins = user.control_fullscreen and 20 or 10,
	Control.main_layout
}

if user.control_fullscreen then
	Control.popup = awful.popup {
		visible = false,
		ontop = true,
		minimum_height = screen[1].workarea.height,
		minimum_width = 510 + beautiful.border_width,
		maximum_width = 510 + beautiful.border_width,
		widget = wibox.widget {
			widget = wibox.container.background,
			bg = beautiful.border_color_normal,
			{
				widget = wibox.container.margin,
				left = beautiful.border_width,
				{
					widget = wibox.container.background,
					bg = beautiful.bg,
					Control.main_widget
				}
			}
		}
	}
else
	Control.popup = awful.popup {
		visible = false,
		ontop = true,
		minimum_height = 490,
		maximum_height = 760,
		minimum_width = 1040,
		maximum_width = 1040,
		border_width = beautiful.border_width,
		border_color = beautiful.border_color_normal,
		widget = Control.main_widget
	}
end

function Control:open(mode)

	if not self.popup.visible then
		self.main_layout:reset()
		Tabbar.main_layout:reset()
		if (user.bar_pos == "Right" or user.bar_pos == "Bottom") and not user.control_fullscreen then
			self.popup.placement = function(d)
				awful.placement.bottom_right(d, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
			end
		elseif user.bar_pos == "Top" and not user.control_fullscreen then
			self.popup.placement = function(d)
				awful.placement.top_right(d, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
			end
		elseif user.bar_pos == "Left" and not user.control_fullscreen then
			self.popup.placement = function(d)
				awful.placement.bottom_left(d, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
			end
		elseif user.bar_pos == "Right" and user.control_fullscreen then
			self.popup.placement = function(d)
				awful.placement.left(d)
			end
		else
			self.popup.placement = function(d)
				awful.placement.right(d)
			end
		end
		self.popup.visible = true

	end

	if mode == "main" then
		Tabbar.index_tab = 1
		Bar:change_bg_container(Info.widget, "on")
		Info.widget.state = true
	elseif mode == "moment" then
		Tabbar.index_tab = 2
		Calendar:set(os.date("*t"))
		Bar:change_bg_container(Clock.widget, "on")
		Clock.widget.state = true
	elseif mode == "system" then
		Tabbar.index_tab = 3
		Tabbar:toggle_timers(true)
	elseif mode == "config" then
		Tabbar.index_tab = 4
	end
	Tabbar:add_tabs()
	self.main_layout:add(Tabbar.main_widget, Tabbar.tabs[Tabbar.index_tab].to)

	if mode ~= "system" then
		Tabbar:toggle_timers(false)
	end
	if mode ~= "main" and Info.widget.state then
		Bar:change_bg_container(Info.widget, "off")
		Info.widget.state = false
	end
	if mode ~= "moment" and Clock.widget.state then
		Bar:change_bg_container(Clock.widget, "off")
		Clock.widget.state = false
	end

end

function Control:close()
	if self.popup.visible then
		self.popup.visible = false
		if Info.widget.state then
			Bar:change_bg_container(Info.widget, "off")
			Info.widget.state = false
		end
		if Clock.widget.state then
			Bar:change_bg_container(Clock.widget, "off")
			Clock.widget.state = false
		end
	end
end

function Control:toggle(mode)
	if self.popup.visible then
		self:close()
	else
		self:open(mode)
	end
end

return Control
