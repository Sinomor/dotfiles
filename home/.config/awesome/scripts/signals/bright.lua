local awful = require("awful")

local Osd = require("ui.osd")
local Bright = {}

Bright.icon = ""
Bright.command = "brightnessctl i"

function Bright:update_value()
	awful.spawn.easy_async_with_shell(self.command, function(stdout)
		local value = stdout:match("(%d?%d?%d?)%%")
		value = tonumber(value)
		awesome.emit_signal("signal::bright", value, self.icon)
	end)
end

function Bright:change_value(x)
	if x == "up" then
		awful.spawn.with_shell("brightnessctl s 5%+")
	else
		awful.spawn.with_shell("brightnessctl s 5%-")
	end
	self:update_value()
	Osd:open()
end

function Bright:set_value(value)
	awful.spawn.with_shell("brightnessctl s " ..value.. "%")
	self:update_value()
end

Bright:update_value()

return Bright
