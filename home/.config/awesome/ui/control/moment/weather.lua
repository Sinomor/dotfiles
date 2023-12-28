local wibox = require("wibox")
local awful = require("awful")
local helpers = require("helpers")
local beautiful = require("beautiful")

local Weather = {}

function Weather:to_direction(deg)
	-- Ref: https://www.campbellsci.eu/blog/convert-wind-directions
	if deg == nil then
		return "Unknown dir"
	end

	local directions = {
		"N", "NNE", "NE", "ENE",
		"E", "ESE", "SE", "SSE",
		"S", "SSW", "SW", "WSW",
		"W", "WNW", "NW", "NNW",
		"N"
	}
	return directions[math.floor((deg%360)/22.5) + 1]
end

Weather.hours_count = 10

Weather.hours_layout = wibox.widget {
	layout = wibox.layout.overflow.horizontal,
	forced_width = 450,
	step = 70,
	scrollbar_enabled = false,
	spacing = 26,
}

function Weather:add_hours(out)
	self.hours_layout:reset()

	for i = 1, self.hours_count do

		local hour_time = self:create_textbox("center")
		local hour_temp = self:create_textbox("center")

		local hour_widget = wibox.widget {
			spacing = 8,
			layout = wibox.layout.fixed.vertical,
			hour_time,
			hour_temp,
		}

		local hour = out.hourly[i]
		hour_temp.markup = hour.temp .. "°C"
		hour_time.text = os.date("%R", hour.dt)

		self.hours_layout:add(hour_widget)
	end
end

Weather.days_count = 7

Weather.days_layout = wibox.widget {
	layout = wibox.layout.overflow.horizontal,
	forced_width = 450,
	step = 50,
	scrollbar_enabled = false,
}

function Weather:add_days(out)
	self.days_layout:reset()

	for i = 1, self.days_count do

		local day = self:create_textbox("center")
		local day_icon = self:create_textbox("center", beautiful.font_name .. " " .. tostring(beautiful.font_size + 15))

		local day_desc = wibox.widget {
			halign = "center",
			valign = "top",
			forced_height = 62,
			widget = wibox.widget.textbox,
		}

		local day_temp_max = self:create_textbox("center")
		local day_temp_min = self:create_textbox("center")

		local day_widget = wibox.widget {
			layout = wibox.layout.fixed.vertical,
			spacing = 10,
			forced_width = 130,
			day,
			day_icon,
			day_desc,
			{
				widget = wibox.container.place,
				halign = "center",
				{
					spacing = 4,
					layout = wibox.layout.fixed.horizontal,
					day_temp_max,
					{
						halign = "center",
						markup = helpers.ui.colorizeText("/", beautiful.fg_alt),
						widget = wibox.widget.textbox,
					},
					day_temp_min,
				}
			}
		}

		local daily = out.daily[i]
		day_icon.text = daily.icon
		day_desc.text = string.lower(daily.desc):gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
		day.text = os.date("%a", daily.dt)
		day_temp_min.markup = daily.temp_night .. "°C"
		day_temp_max.markup = daily.temp_day .. "°C"

		self.days_layout:add(day_widget)
	end
end

Weather.main_icon = wibox.widget {
	forced_width = 80,
	forced_height = 80,
	halign = "left",
	valign = "top",
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 28),
	widget = wibox.widget.textbox
}

function Weather:create_textbox(halign, font)
	return wibox.widget {
		halign = halign,
		widget = wibox.widget.textbox,
		font = font,
		markup = helpers.ui.colorizeText("Hello")
	}
end

Weather.main_desc = Weather:create_textbox("left")
Weather.main_timezone = Weather:create_textbox("left")
Weather.main_temp = Weather:create_textbox("right", beautiful.font_name .. " " .. tostring(beautiful.font_size + 8))
Weather.main_feels = Weather:create_textbox("right")
Weather.main_humid = Weather:create_textbox("right")
Weather.main_wind = Weather:create_textbox("right")

Weather.main_widget = wibox.widget {
	widget = wibox.container.background,
	forced_width = 470,
	bg = beautiful.bg_alt,
	{
		widget = wibox.container.margin,
		margins = 20,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 20,
			{
				layout = wibox.layout.align.horizontal,
				{
					layout = wibox.layout.fixed.vertical,
					spacing = 4,
					Weather.main_icon,
					{
						layout = wibox.layout.fixed.vertical,
						spacing = 8,
						Weather.main_desc,
						Weather.main_timezone,
					}
				},
				{
					spacing = 8,
					layout = wibox.layout.fixed.vertical,
					Weather.main_temp,
					Weather.main_humid,
					Weather.main_feels,
					Weather.main_wind
				},
			},
			Weather.hours_layout,
			{
				widget = wibox.container.background,
				forced_height = beautiful.border_width,
				bg = beautiful.bg_urgent
			},
			Weather.days_layout
		}
	}
}

awesome.connect_signal("signal::weather", function(out)
	Weather.main_icon.markup = out.current.icon
	Weather.main_desc.markup = string.lower(out.current.desc):gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
	Weather.main_temp.markup = out.current.temp .. "°C"
	Weather.main_feels.markup = "Feels Like " .. out.current.feels_like .. "°C"
	Weather.main_humid.markup = "Humidity: " .. out.current.humidity .. "%"
	Weather.main_timezone.markup = out.timezone
	Weather.main_wind.markup = "Wind: " .. out.current.wind_speed .. " m/s (" .. Weather:to_direction(out.current.wind_deg) .. ")"
	Weather:add_hours(out)
	Weather:add_days(out)
end)

return Weather
