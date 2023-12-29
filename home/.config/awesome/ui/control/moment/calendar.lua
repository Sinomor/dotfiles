local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local user = require("user")

local Cal = {}
local Title = {}

function Cal:create_month_widget(month, color)
	local fg_color = color or beautiful.fg
	return wibox.widget {
		widget = wibox.container.background,
		fg = fg_color,
		{
			widget = wibox.widget.textbox,
			halign = "center",
			text = month
		}
	}
end

function Cal:create_day_widget(day, is_current, is_another_month)
	local fg_color = beautiful.fg
	local bg_color = beautiful.bg_alt

	if is_current then
		fg_color = beautiful.bg
		bg_color = beautiful.accent
	elseif is_another_month then
		fg_color = beautiful.fg_alt
		bg_color = beautiful.bg_alt
	end

	return wibox.widget {
		widget = wibox.container.background,
		forced_width = 40,
		forced_height = 40,
		fg = fg_color,
		bg = bg_color,
		{
			widget = wibox.widget.textbox,
			halign = "center",
			text = day
		}
	}
end

Cal.m_layout = wibox.widget {
	forced_num_rows = 7,
	forced_num_cols = 7,
	vertical_spacing = 12,
	horizontal_spacing = 26,
	layout = wibox.layout.grid,
}
if not user.control_fullscreen then
	Cal.m_layout.vertical_spacing = 20
end


Title.MY = wibox.widget {
	widget = wibox.widget.textbox,
	align = "center"
}

function Title:create_title_button(text)
	local widget = wibox.widget {
		widget = wibox.container.background,
		{
			widget = wibox.container.margin,
			margins = 8,
			{
				widget = wibox.widget.textbox,
				text = text,
				font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 3),
			}
		}
	}
	widget:connect_signal("mouse::enter", function()
		helpers.ui.transitionColor {
			old = beautiful.bg_alt,
			new = beautiful.bg_urgent,
			transformer = function(col)
				widget:set_bg(col)
			end,
			duration = 0.8
		}
	end)
	widget:connect_signal("mouse::leave", function()
		helpers.ui.transitionColor {
			old = beautiful.bg_urgent,
			new = beautiful.bg_alt,
			transformer = function(col)
				widget:set_bg(col)
			end,
			duration = 0.8
		}
	end)
	return widget
end

Title.dec_but = Title:create_title_button("")
Title.dec_but:buttons {
	awful.button({}, 1, function()
		Cal:inc(-1)
	end)
}

Title.inc_but = Title:create_title_button("")
Title.inc_but:buttons {
	awful.button({}, 1, function()
		Cal:inc(1)
	end)
}

Title.m_widget = wibox.widget {
	layout = wibox.layout.align.horizontal,
	Title.dec_but,
	Title.MY,
	Title.inc_but
}


local wday_table = {
	[1] = 7,
	[2] = 1,
	[3] = 2,
	[4] = 3,
	[5] = 4,
	[6] = 5,
	[7] = 6
}

function Cal:set(date)
	self.m_layout:reset()
	self.date = date
	local curr_date = os.date("*t")

	local firstday = os.date("*t", os.time({ year = date.year, month = date.month, day = 1 }))
	local lastday = os.date("*t", os.time({ year = date.year, month = date.month + 1, day = 0 }))

	local month_count = lastday.day

	local month_prev_lastday = os.date("*t", os.time({ year = date.year, month = date.month, day = 0 })).day

	local month_prev_count = wday_table[firstday.wday] - 1
	local month_next_count = 42 - lastday.day - month_prev_count

	Title.MY.text = os.date("%B, %Y", os.time(date))

	self.m_layout:add(
	self:create_month_widget("Mon"),
	self:create_month_widget("Tue"),
	self:create_month_widget("Wed"),
	self:create_month_widget("Thu"),
	self:create_month_widget("Fri"),
	self:create_month_widget("Sat", beautiful.red),
	self:create_month_widget("Sun", beautiful.red)
	)

	for day = month_prev_lastday - (month_prev_count - 1), month_prev_lastday, 1 do
		self.m_layout:add(self:create_day_widget(day, false, true))
	end

	for day = 1, month_count, 1 do
		local is_current = day == curr_date.day and date.month == curr_date.month and date.year == curr_date.year
		self.m_layout:add(self:create_day_widget(day, is_current, false))
	end

	for day = 1, month_next_count, 1 do
		self.m_layout:add(self:create_day_widget(day, false, true))
	end
end

function Cal:inc(dir)
	local new_calendar_month = self.date.month + dir
	self:set({ year = self.date.year, month = new_calendar_month, day = self.date.day })
end

Cal.main_widget = wibox.widget {
	widget = wibox.container.background,
	forced_width = 470,
	bg = beautiful.bg_alt,
	{
		widget = wibox.container.margin,
		margins = 20,
		{
			widget = wibox.container.place,
			halign = "center",
			valign = "center",
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 10,
				Title.m_widget,
				Cal.m_layout
			}
		}
	}
}

return Cal
