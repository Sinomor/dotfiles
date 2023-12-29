local awful = require("awful")
local user = require("user")
local gears = require("gears")

local Wall = require("scripts.awesome.wallpapers")
local Pipewire = require("daemons.pipewire")
local Bluetooth = require("daemons.bluetooth")
local Wifi = require("daemons.wifi")

gears.timer {
	autostart = true,
	single_shot = true,
	callback = function()
		Wall:change_wall(user.wall_type)
		Pipewire:update_value()
		Pipewire:update_value_capture()
		Bluetooth:get_status()
		Wifi:get_status()
		if user.opacity_value then
			awful.spawn(user.awm_config .. "other/picom/launch.sh --opacity")
		else
			awful.spawn(user.awm_config .. "other/picom/launch.sh --no-opacity")
		end
		for _, command in ipairs(user.autostart) do
			awful.spawn(command)
		end
	end,
}
