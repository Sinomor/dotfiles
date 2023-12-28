local awful = require("awful")
local gears = require("gears")

local Top = {}

Top.command = [[
	bash -c "ps -eo user,pid,%cpu,%mem,comm --sort=-%cpu | head -n 21 | tail -n 20"
]]

function Top:gen_top_list()
	local list = {}
	awful.spawn.easy_async_with_shell(Top.command, function(stdout, stderr, reason, code)
		for line in stdout:gmatch("[^\n]+") do
			user, pid, cpu, mem, comm = line:match("(.-)%s+(.-)%s+(.-)%s+(.-)%s+(.*)")
			if comm ~= "ps" then
				table.insert(list, { user = user, pid = pid, cpu = cpu, mem = mem, name = comm })
			end
		end
		if reason == "exit" then
			awesome.emit_signal("signal::top", list)
		end
	end)
end

Top.timer = gears.timer {
	call_now = false,
	autostart = false,
	timeout = 4,
	callback = function()
		Top:gen_top_list()
	end,
}

return Top
