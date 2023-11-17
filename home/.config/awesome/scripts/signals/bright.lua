local awful = require("awful")

local icon = ""
local command = "brightnessctl i"

function update_value_of_bright()
	awful.spawn.easy_async_with_shell(command, function(stdout)
		local value = stdout:match("(%d?%d?%d?)%%")
		value = tonumber(value)
		awesome.emit_signal("bright::value", value, icon)
	end)
end

update_value_of_bright()

