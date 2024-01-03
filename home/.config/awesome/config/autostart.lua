local awful = require("awful")
local user = require("user")
local gears = require("gears")

local beautiful = require("beautiful")
beautiful.init("~/.config/awesome/theme/theme.lua")

local Wall = require("scripts.wallpapers")
local Bright = require("daemons.bright")
local Disk = require("daemons.disk")
local Pipewire = require("daemons.pipewire")
local Bluetooth = require("daemons.bluetooth")
local Wifi = require("daemons.wifi")

require("daemons.stats")
require("daemons.weather")
if user.battery then
require("daemons.bat")
end

gears.timer {
	autostart = true,
	single_shot = true,
	callback = function()
		Wall:change_wall(user.wall_type)
		Pipewire.timer:start()
		Bright:update_value()
		Bluetooth:get_status()
		Wifi:get_status()
		Disk:all()
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
