local awful = require("awful")
local gears = require("gears")

local Osd = require("ui.osd")
local Pipewire = {}

Pipewire.icon = ""

function Pipewire:update_value()
	awful.spawn.easy_async_with_shell("amixer -D pipewire sget Master", function(stdout)
		local value = stdout:match("(%d?%d?%d)%%")
		local muted = stdout:match("%[(o%D%D?)%]")
		value = tonumber(value)
		if muted == "off" then
			self.icon = ""
		elseif value <= 33 then
			self.icon = ""
		elseif value <= 66 then
			self.icon = ""
		elseif value <= 100 then
			self.icon = ""
		end
		awesome.emit_signal("signal::volume", value, self.icon)
	end)
end

function Pipewire:update_value_capture()
	awful.spawn.easy_async_with_shell("amixer sget Capture toggle", function(stdout)
		local value = stdout:match("%[(o%D%D?)%]")
		awesome.emit_signal("signal::capture", value)
	end)
end

Pipewire.script = [[
	bash -c "pactl subscribe | rg --line-buffered "change""
]]

awful.spawn.easy_async({'pkill', '--full', '--uid', os.getenv('USER'), '^pactl subscribe'}, function()
	awful.spawn.with_line_callback(Pipewire.script, {
		stdout = function() Pipewire:update_value() end
	})
end)

function Pipewire:change_value(x)
	if x == "up" then
		awful.spawn.with_shell("amixer -D pipewire sset Master 2%+")
	elseif x == "down" then
		awful.spawn.with_shell("amixer -D pipewire sset Master 2%-")
	else
		awful.spawn.with_shell("amixer -D pipewire sset Master toggle")
	end
	Osd:open()
end

function Pipewire:set_value(value)
	awful.spawn.with_shell("amixer -D pipewire sset Master " ..value.. "%")
end

function Pipewire:toggle_capture()
	awful.spawn.with_shell("amixer -D pipewire sset Capture toggle")
	self:update_value_capture()
end

Pipewire.start = gears.timer {
	timeout = 1,
	single_shot = true,
	callback = function()
		Pipewire:update_value()
		Pipewire:update_value_capture()
	end
}

return Pipewire
