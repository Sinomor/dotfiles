----------------------------------------
-- @author https://github.com/myagko
----------------------------------------
local awful = require("awful")

local Bluetooth = {}

function Bluetooth:get_status()
	awful.spawn.easy_async_with_shell("bluetoothctl show", function(stdout)
		local st = stdout:match("Powered:%s+(%w+)")
		if st == "yes" then
			self.status = true
		else
			self.status = false
		end
		awesome.emit_signal("signal::bluetooth", self.status)
	end)
end

function Bluetooth:toggle()
	if not self.status then
		awful.spawn.easy_async_with_shell("bluetoothctl power on", function()
			self:get_status()
		end)
	else
		awful.spawn.easy_async_with_shell("bluetoothctl power off", function()
			self:get_status()
		end)
	end
end

Bluetooth:get_status()

return Bluetooth
