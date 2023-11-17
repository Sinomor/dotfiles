local gears = require("gears")
local awful = require("awful")
local user = require("user")
local color = require("theme.colors."..user.color)

local walls = io.popen("ls ~/.walls/ | shuf"):lines()
local lut = color.lut
local prev_random = 1

local function return_random()
	local new_random = math.random(1, 69)
	if new_random ~= prev_random then
		prev_random = new_random
		return new_random
	else
		return_random()
	end
end

return_random()
wall = walls(new_random)

function change_wall()
		awful.spawn.easy_async_with_shell([[ 
			bash -c " 
			$HOME/.local/bin/lutgen apply --hald-clut "]] ..lut.. [[" .walls/"]] ..wall.. [[" -o ~/.config/awesome/theme/wall.jpg &&
			feh --bg-fill ~/.config/awesome/theme/wall.jpg &&
			convert ~/.config/awesome/theme/wall.jpg -resize 1920x1080 \
			+repage -crop 390x478+765+301 ~/.config/awesome/theme/launcher/image.jpg"
		]], function()
			return_random()
			wall = walls(new_random)
		end)
end


gears.timer {
	call_now = true,
	autostart = true,
	timeout = 1800,
	callback = change_wall,
}

