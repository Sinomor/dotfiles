local awful = require("awful")

local C = {}
local R = {}

C.interval = 4
C.script = [[
	sh -c "vmstat 1 2 | tail -1 | awk '{printf \"%d\", $15}'"
]]

awful.widget.watch(C.script, C.interval, function(widget, stdout)
	local cpu_idle = stdout
	cpu_idle = string.gsub(cpu_idle, '^%s*(.-)%s*$', '%1')
	awesome.emit_signal("signal::cpu", 100 - tonumber(cpu_idle))
end)

R.interval = 20
R.script = [[
	sh -c "free -m | grep 'Mem:' | awk '{printf \"%d@@%d@\", $7, $2}'"
]]

awful.widget.watch(R.script, C.interval, function(widget, stdout)
	local available = stdout:match('(.*)@@')
	local total = stdout:match('@@(.*)@')
	local used = tonumber(total) - tonumber(available)
	local value = math.floor((used/total)*100)
	awesome.emit_signal("signal::ram", value)
end)
