local gears = require("gears")
local awful = require("awful")
local user = require("user")
local color = require("theme.colors."..user.color)
local wibox = require("wibox")
local beautiful = require("beautiful")

local Wall = {}

Wall.command = [[
	bash -c "ls -1 ]] ..user.awm_config.. [[theme/walls/"
]]

Wall.list = {}
function Wall:gen_wall_list()
	awful.spawn.easy_async_with_shell(self.command, function(stdout, stderr, reason, code)
		for line in stdout:gmatch("[^\n]+") do
			table.insert(self.list, line)
		end
		if reason == "exit" then
			self:return_random()
			self.timer:start()
			self:change_wall("Random")
		end
	end)
end


Wall.colors = { "green", "cyan", "red", "yellow", "blue", "orange", "violet", "bg_urgent", "fg", "fg_alt" }

Wall.tile_diagonal_line = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'..
'<svg width="' ..user.wall_tile_size.. '" height="' ..user.wall_tile_size.. '">'..
'<rect x="0"  y="0" width="' ..user.wall_tile_size.. '" height="' ..user.wall_tile_size.. '" fill="' ..beautiful.bg.. '" />'..
'<polyline points="0,' ..user.wall_tile_size.. '  ' ..user.wall_tile_size.. ',0" stroke="' ..beautiful.border_color_normal.. '" width="' ..beautiful.border_width.. '" />'..
'</svg>'

Wall.tile_dots = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>'..
'<svg width="' ..user.wall_tile_size.. '" height="' ..user.wall_tile_size.. '">'..
'<rect x="0"  y="0" width="' ..user.wall_tile_size.. '" height="' ..user.wall_tile_size.. '" fill="' ..beautiful.bg.. '" />'..
'<rect x="0"  y="0" width="' ..beautiful.border_width.. '" height="' ..beautiful.border_width.. '" fill="' ..beautiful.border_color_normal.. '" />'..
'</svg>'

function Wall:create_tile(s, img)
	return awful.wallpaper {
		screen = s,
		widget = {
			{
				widget = wibox.widget.imagebox,
				resize = false,
				image = img
			},
			tiled = true,
			widget = wibox.container.tile
		}
	}
end

function Wall:create_color(s, cl)
	return awful.wallpaper {
		screen = s,
		widget = {
			widget = wibox.container.background,
			bg = cl,
			forced_width = s.geometry.width,
			forced_height = s.geometry.height,
		}
	}
end

Wall.lut = color.lut
Wall.prev_random = 1

function Wall:return_random()
	self.new_random = math.random(1, #self.list)
	if self.new_random ~= self.prev_random then
		self.prev_random = self.new_random
		return self.new_random
	else
		self:return_random()
	end
end

function Wall:change_wall(type, value)
	if type == "Random" then
		if #self.list == 0 then
			self:gen_wall_list()
		else
			local wall = self.list[Wall.new_random]
			local lutgen_script = user.bins.lutgen.. [[ apply --hald-clut ]] ..self.lut.. [[ ]] ..user.awm_config.. [[/theme/walls/]] ..wall.. [[ -o ]] ..user.awm_config.. [[theme/wall.jpg]]
			awful.spawn.easy_async_with_shell(lutgen_script, function(stdout, stderr, reason, code)
				if reason == "exit" then
					self:return_random()
					awful.spawn.easy_async_with_shell([[feh --bg-fill ]] ..user.awm_config.. [[theme/wall.jpg]])
				end
			end)
		end
	elseif type == "Colorized" then
		awful.screen.connect_for_each_screen(function(s)
			self:create_color(s, user.wall_color)
		end)
	elseif type == "Tile" then
		value = value or user.wall_tile_type
		awful.screen.connect_for_each_screen(function(s)
			if value == "Diagonal Line" then
				self:create_tile(s, self.tile_diagonal_line)
			elseif value == "Dots" then
				self:create_tile(s, self.tile_dots)
			end
		end)
	end
end

Wall.timer = gears.timer {
	timeout = user.wall_update,
	callback = function()
		Wall:change_wall("Random")
	end
}

return Wall
