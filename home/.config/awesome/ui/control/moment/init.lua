local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")
local user = require("user")

local Weather = require("ui.control.moment.weather")
local Calendar = require("ui.control.moment.calendar")

local Moment = {}

Moment.main_widget = wibox.widget {
	layout = user.control_fullscreen and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal,
	spacing = 10,
	Calendar.main_widget,
	Weather.main_widget,
}

return Moment
