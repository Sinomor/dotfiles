local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local rubato = require("modules.rubato")
local user = require("user")
local helpers = require("helpers")
local gears = require("gears")
local naughty = require("naughty")

local Create_toggle = require("ui.control.main.toggle")
local Create_slider = require("ui.control.main.slider")

local Bluetooth = require("scripts.signals.bluetooth")
local Bright = require("scripts.signals.bright")
local Volume = require("scripts.signals.vol")
local Wifi_daemon = require("scripts.signals.wifi")
local Wifi_applet = require("ui.control.main.wifi_applet")
local Notifs_list = require("ui.control.main.notifs_list")
local Music = require("ui.control.main.music")

local Main = {}

-- sliders --

Main.volume = Create_slider({
	color = beautiful.orange,
	signal = "signal::volume",
	command = "amixer -D pipewire sset Master %d%%"
})
Main.volume:buttons {
	awful.button({}, 3, function()
		Volume:change_value("mute")
	end)
}

Main.bright = Create_slider({
	signal = "signal::bright",
	color = beautiful.violet,
	command = "brightnessctl s %d%%"
})

Main.info = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.bg_alt,
	forced_height = 108,
	{
		widget = wibox.container.margin,
		margins = 10,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 20,
			Main.volume,
			Main.bright,
		}
	}
}

-- toggles --

Main.wifi_toggle = Create_toggle({
	icon = "",
	name = "Wifi",
	value = "On",
	arroy_visible = true,
	click_func = function() Wifi_daemon:toggle() end,
	arroy_func = function() Wifi_applet:toggle() end
})

awesome.connect_signal("wifi:status", function(value)
	if not value then
		Main.wifi_toggle.change("off")
	else
		Main.wifi_toggle.change("on")
	end
end)

Main.bluetooth_toggle = Create_toggle({
	icon = "",
	name = "Bluetooth",
	value = "On",
	arroy_visible = false,
	click_func = function() Bluetooth:toggle() end
})

awesome.connect_signal("signal::bluetooth", function(value)
	if not value then
		Main.bluetooth_toggle.change("off")
	else
		Main.bluetooth_toggle.change("on")
	end
end)

Main.micro_toggle = Create_toggle({
	icon = "",
	name = "Microphone",
	value = "On",
	arroy_visible = false,
	click_func = function() Volume:toggle_capture() end
})

awesome.connect_signal("signal::capture", function(value)
	if value == "off" then
		Main.micro_toggle.change("off")
	else
		Main.micro_toggle.change("on")
	end
end)

Main.dnd_toggle = Create_toggle({
	icon = "",
	name = "Silent mode",
	value = "On",
	arroy_visible = false,
	click_func = function()
		local Bar = require("ui.bar")
		Bar:dnd_toggle()
		if naughty.is_suspended() then
			Main.dnd_toggle.change("on")
		else
			Main.dnd_toggle.change("off")
		end
	end
})

if naughty.is_suspended() then
	Main.dnd_toggle.change("on")
else
	Main.dnd_toggle.change("off")
end

Main.toggles = wibox.widget {
	layout = wibox.layout.grid,
	spacing = 10,
	forced_num_cols = 2,
	Main.wifi_toggle,
	Main.bluetooth_toggle,
	Main.micro_toggle,
	Main.dnd_toggle
}

if user.control_fullscreen then
	Main.main_widget = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		spacing = 10,
		Main.toggles,
		Main.info,
		Music.main_widget,
		Notifs_list.main_widget
	}
else
	Main.main_widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 10,
		{
			layout = wibox.layout.fixed.vertical,
			forced_width = 470,
			spacing = 10,
			Main.toggles,
			Main.info,
			Music.main_widget,
		},
		Notifs_list.main_widget
	}
end

return Main
