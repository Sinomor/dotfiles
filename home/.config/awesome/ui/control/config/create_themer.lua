local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local user = require("user")
local helpers = require("helpers")
local user_file = "~/.config/awesome/user.lua"

local Themer = {}

Themer.colorshemes = { "biscuit", "rosepine_light", "everforest", "mountain", "stardew", "catppuccin", "gruvbox", "gruvbox_light", "nymph" }
Themer.colors = { "bg", "bg_urgent", "fg", "fg_alt", "green", "yellow", "blue", "red", "orange", "violet", "cyan" }

function Themer:create_theme_color(color, name)

	local widget = wibox.widget {
		widget = wibox.container.background,
		forced_width = 30,
		forced_height = 30,
		bg = color
	}

	local popup = awful.tooltip {
		objects = { widget },
		timer_function = function()
			return name
		end,
		mode = "mouse",
		gaps = beautiful.useless_gap,
		margins_leftright = 10,
		margins_topbottom = 10,
		delay_show = 0.5
	}

	return widget
end

function Themer:create_theme_button(text)
	return wibox.widget {
		widget = wibox.widget.textbox,
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 3),
		text = text
	}
end

function Themer:create_themes(colorsheme)

	local clsh = require("theme.colors."..colorsheme)
	self.index = helpers.ui.get_index(self.colorshemes, colorsheme)

	local text = wibox.widget {
		widget = wibox.widget.textbox,
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 1),
		markup = colorsheme:gsub("^%l", string.upper)
	}

	local colors_layout = wibox.widget {
		layout = wibox.layout.grid,
		homogeneous = false,
		expand = false,
		forced_num_cols = 11,
		spacing = 10,
	}

	for _, color in ipairs(self.colors) do
		colors_layout:add(self:create_theme_color(clsh[color], color))
	end

	local next = self:create_theme_button("")
	next:buttons {
		awful.button({}, 1, function()
			if self.index ~= #self.colorshemes then
				self.index = self.index + 1
			else
				self.index = 1
			end
			local Config = require("ui.control.config")
			Config.colorsheme_layout:remove(2)
			Config.colorsheme_layout:insert(2, self:create_themes(self.colorshemes[self.index]))
		end)
	}

	local prev = self:create_theme_button("")
	prev:buttons {
		awful.button({}, 1, function()
			if self.index ~= 1 then
				self.index = self.index - 1
			else
				self.index = #self.colorshemes
			end
			local Config = require("ui.control.config")
			Config.colorsheme_layout:remove(2)
			Config.colorsheme_layout:insert(2, self:create_themes(self.colorshemes[self.index]))
		end)
	}

	local widget = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		spacing = 20,
		{
			layout = wibox.layout.align.horizontal,
			text,
			nil,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 10,
				prev,
				next
			}
		},
		colors_layout,
	}

	return widget
end

return Themer
