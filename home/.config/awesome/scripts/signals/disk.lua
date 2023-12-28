local awful = require("awful")
local gears = require("gears")

local Disk = {}

Disk.disk_script = [[
	sh -c "df -h /"
]]
Disk.command = [[
	bash -c "du -hd 1 ~/ | sed -e 's/\/\home\/sinomor/~/g'"
]]

function Disk.gen_disk_list()
	list = {}
	awful.spawn.easy_async_with_shell(Disk.command, function(stdout, stderr, reason, code)
		for line in stdout:gmatch("[^\n]+") do
			size, dir = line:match("(.-)%s+(.*)")
			if tonumber(size) ~= 0 then
				table.insert(list, { dir = dir, size = size })
			end
		end
		if reason == "exit" then
			awesome.emit_signal("signal::disk_list", list)
		end
	end)
end

function Disk.get_disk()
	awful.spawn.easy_async_with_shell(Disk.disk_script, function(stdout)
		local value = stdout:match("%s(%d+)%%")
		awesome.emit_signal("signal::disk", value)
	end)
end

function Disk.all()
	Disk.gen_disk_list()
	Disk.get_disk()
end

Disk.timer = gears.timer {
	autostart = true,
	single_shot = true,
	timeout = 0.1,
	callback = Disk.all,
}

return Disk
