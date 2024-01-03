local awful = require("awful")
local gears = require("gears")
local user = require("user")

local Osd = require("ui.osd")
local Pipewire = {}
Pipewire.val_prev = -1
Pipewire.muted_prev = "no"

function Pipewire:get_volume()
	awful.spawn.easy_async_with_shell("pactl get-sink-mute @DEFAULT_SINK@", function(std)
		self.muted = std:match("%s+(%w+)")
	end)
	awful.spawn.easy_async_with_shell("pactl get-sink-volume @DEFAULT_SINK@", function(stdout)
		local value = stdout:match(("/%s+(%d+)"))
		value = tonumber(value)
		if value ~= self.val_prev or self.muted ~= self.muted_prev then
			if self.muted == "yes" then
				self.icon = ""
			elseif value <= 33 then
				self.icon = ""
			elseif value <= 66 then
				self.icon = ""
			elseif value <= 100 then
				self.icon = ""
			end
			awesome.emit_signal("signal::volume", value, self.icon)
		end
	end)
end

function Pipewire:get_capture()
	awful.spawn.easy_async_with_shell("amixer sget Capture toggle", function(stdout)
		local value = stdout:match("%[(o%D%D?)%]")
		awesome.emit_signal("signal::capture", value)
	end)
end

function Pipewire:change_value(x)
	if x == "up" then
		awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +2%")
	elseif x == "down" then
		awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -2%")
	else
		awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")
	end
	Osd:open()
	self:get_volume()
end

function Pipewire:set_value(value)
	awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ " ..value.. "%")
end

function Pipewire:toggle_capture()
	awful.spawn.with_shell("amixer -D pipewire sset Capture toggle")
	self:get_capture()
end

Pipewire.timer = gears.timer {
	timeout = 1,
	single_shot = true,
	callback = function()
		Pipewire:get_capture()
		Pipewire:get_volume()
	end
}

return Pipewire
