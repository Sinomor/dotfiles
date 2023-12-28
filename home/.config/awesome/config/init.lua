local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local rubato = require("modules.rubato")
local user = require("user")
local helpers = require("helpers")
local user_file = "~/.config/awesome/user.lua"
local naughty = require("naughty")

local Pathbox = require("ui.control.config.create_pathbox")
local Passbox = require("ui.control.config.create_passbox")
local Inputbox = require("ui.control.config.create_inputbox")
local Numberbox = require("ui.control.config.create_numberbox")
local Toggle = require("ui.control.config.create_toggle")
local Dropmenu = require("ui.control.config.create_dropmenu")
local Themer = require("ui.control.config.create_themer")

local Themers = require("scripts.awesome.apply_theme")
local Wall = require("scripts.awesome.wallpapers")

local Config = {}

Config.apply_widget = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.bg_alt,
	forced_height = 40,
	forced_width = 100,
	buttons = {
		awful.button({}, 1, function()
			if Themer.colorshemes[Themer.index] ~= user.color then
				Themers:apply_theme(Themer.colorshemes[Themer.index])
			else
				awesome.restart()
			end
		end)
	},
	{
		widget = wibox.widget.textbox,
		halign = "center",
		text = "Apply Config"
	}
}

function Config:create_titlebar(name, color)
	color = color or beautiful.bg_urgent

	local text = wibox.widget {
		widget = wibox.widget.textbox,
		text = name
	}

	local widget = wibox.widget {
		widget = wibox.container.background,
		bg = color,
		forced_height = 40,
		{
			widget = wibox.container.margin,
			margins = { right = 10, left = 10 },
			text
		}
	}

	return widget
end

function Config:create_container(widget)
	local box = wibox.widget {
		widget = wibox.container.constraint,
		strategy = "max",
		height = 1000,
		{
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			{
				widget = wibox.container.margin,
				margins = 20,
				widget
			}
		}
	}
	return box
end

Config.apps_title = Config:create_titlebar("Applications")
Config.apps_terminal = Inputbox("terminal", "Terminal")
Config.apps_browser = Inputbox("browser", "Browser")
Config.apps_filemanager = Inputbox("file_manager", "File Manager")

Config.apps = Config:create_container( wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = 10,
	Config.apps_title,
	Config.apps_terminal,
	Config.apps_browser,
	Config.apps_filemanager,
})

Config.ui_title = Config:create_titlebar("UI")
Config.ui_font_name = Inputbox("font_name", "Font")
Config.ui_font_size = Numberbox("font_size", "Font Size")
Config.ui_gaps = Numberbox("useless_gap", "Gaps")
Config.ui_bar_size = Numberbox("bar_size", "Bar size")

Config.ui_wall_type = Dropmenu("wall_type", "Wallpaper Type", { "Tile", "Random", "Colorized" })
Config.ui_wall_update = Numberbox("wall_update", "Cycle Wall")
Config.ui_wall_color = Inputbox("wall_color", "Wallpaper Color")
Config.ui_wall_tile_type = Dropmenu("wall_tile_type", "Wallpaper Tile Type", { "Diagonal Line", "Dots" })
Config.ui_wall_tile_size = Numberbox("wall_tile_size", "Wallpaper Tile Size")

Config.ui_bar_pos = Dropmenu("bar_pos", "Bar Position", { "Right", "Left", "Top", "Bottom" })
Config.ui_titlebar_pos = Dropmenu("titlebar_pos", "Titlebar Position", { "Right", "Left", "Top", "Bottom" })
Config.ui_notifs_pos = Dropmenu("notifs_pos", "Notifs Position", { "top_right", "top_middle", "top_left", "bottom_right", "bottom_middle", "bottom_left" })
Config.ui_opacity = Toggle("opacity_value", "Compositor Opacity")
Config.ui_launcher = Toggle("launcher_fullscreen", "Fullscreen Launcher")
Config.ui_control = Toggle("control_fullscreen", "Fullscreen Control")
Config.ui_bar_float = Toggle("bar_float", "Floating Bar")

Config.ui_layout = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = 10,
	Config.ui_title,
	Config.ui_font_name,
	Config.ui_font_size,
	Config.ui_gaps,
	Config.ui_border_width,
	Config.ui_bar_size,
	Config.ui_bar_float,
	Config.ui_wall_type,
	Config.ui_titlebar_pos,
	Config.ui_notifs_pos,
	Config.ui_bar_pos,
	Config.ui_launcher,
	Config.ui_control,
	Config.ui_opacity
}
Config.ui = Config:create_container(Config.ui_layout)

Config.colorsheme_layout = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = 10,
	Config:create_titlebar("Colorsheme"),
	Themer:create_themes(user.color)
}
Config.colorsheme = Config:create_container(Config.colorsheme_layout)

if user.control_fullscreen then
	Config.main_layout = wibox.widget {
		layout = wibox.layout.overflow.vertical,
		scrollbar_enabled = false,
		forced_height = 920,
		spacing = 10,
		step = 100,
		Config.ui,
		Config.colorsheme,
		Config.apps,
	}
else
	Config.main_layout = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		spacing = 10,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = 10,
			{
				layout = wibox.layout.overflow.vertical,
				forced_height = 500,
				scrollbar_enabled = false,
				step = 100,
				Config.ui,
			},
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 10,
				Config.colorsheme,
				Config.apps,
			},
		},
		Config.apply_widget
	}
end

Config.main_widget = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = 10,
	Config.main_layout,
	Config.apply_widget
}
if user.control_fullscreen then
	Config.main_widget.forced_height = 970
else
	Config.ui.forced_width = 470
	Config.apps.forced_width = 470
	Config.colorsheme.forced_width = 470
end

if not user.control_fullscreen then
	Config.main_widget:remove(Config.main_widget:index(Config.apply_widget))
end

function Config:add_missing(var, value)
	if var == "wall_type" then
		local wall_index = Config.ui_layout:index(Config.ui_wall_type)
		if value == "Random" then
			if self.ui_layout:index(self.ui_wall_update) == nil then
				self.ui_layout:insert(wall_index + 1, self.ui_wall_update)
			end
		else
			self.ui_layout:remove(self.ui_layout:index(self.ui_wall_update))
		end
		if value == "Colorized" then
			if self.ui_layout:index(self.ui_wall_color) == nil then
				self.ui_layout:insert(wall_index + 1, self.ui_wall_color)
			end
		else
			self.ui_layout:remove(self.ui_layout:index(self.ui_wall_color))
		end
		if value == "Tile" then
			if self.ui_layout:index(self.ui_wall_tile_type) == nil then
				self.ui_layout:insert(wall_index + 1, self.ui_wall_tile_type)
				self.ui_layout:insert(wall_index + 2, self.ui_wall_tile_size)
			end
		else
			self.ui_layout:remove(self.ui_layout:index(self.ui_wall_tile_type))
			self.ui_layout:remove(self.ui_layout:index(self.ui_wall_tile_size))
		end
	end
end

Config:add_missing("wall_type", user.wall_type)

awesome.connect_signal("droplist::change", function(var, value)
	Config:add_missing(var, value)
	if var == "wall_tile_type" then
		Wall:change_wall("Tile", value)
	end
	if var == "wall_type" then
		if value == "Random" then
			Wall:change_wall("Random")
		elseif value == "Tile" then
			Wall:change_wall("Tile")
		end
	end
end)

return Config
