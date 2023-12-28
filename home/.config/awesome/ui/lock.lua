local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local beautiful = require("beautiful")
local user = require("user")
local pam = require("liblua_pam")

local Lock = {}

screen.connect_signal("request::desktop_decoration", function(s)

function Lock:authenticate(password)
	return pam.auth_current_user(password)
end

Lock.characters_entered = 0

Lock.header = wibox.widget {
	widget = wibox.container.place,
	halign = "center",
	{
		layout = wibox.layout.fixed.vertical,
		spacing = 10,
		{
			widget = wibox.widget.imagebox,
			image = beautiful.profile_image,
			forced_width = 140,
			forced_height = 140,
		},
		{
			widget = wibox.widget.textbox,
			halign = "center",
			text = "@" .. user.name:gsub("^%l", string.upper)
		}
	}
}

Lock.time = wibox.widget {
	widget = wibox.container.place,
	halign = "center",
	{
		layout = wibox.layout.fixed.horizontal,
		spacing = 20,
		{
			widget = wibox.widget.textclock,
			font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 26),
			format = "%H",
		},
		{
			widget = wibox.container.margin,
			top = 20,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 10,
				helpers.ui.create_point(beautiful.green, 10),
				helpers.ui.create_point(beautiful.yellow, 10),
				helpers.ui.create_point(beautiful.red, 10),
			},
		},
		{
			widget = wibox.widget.textclock,
			font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 26),
			format = "%M",
		}
	}
}

Lock.prompt = wibox.widget {
	widget = wibox.widget.textbox,
	markup = "type...",
}

Lock.prompt_pass = wibox.widget.textbox()

Lock.button = wibox.widget {
	widget = wibox.widget.textbox,
	text = "",
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 1),
}

Lock.promptbox = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.bg_alt,
	forced_width = 240,
	forced_height = 60,
	{
		widget = wibox.container.margin,
		margins = { right = 10, left = 10 },
		{
			layout = wibox.layout.align.horizontal,
			{
				layout = wibox.layout.fixed.horizontal,
				id = "main",
				Lock.prompt,
			},
			nil,
			Lock.button
		}
	}
}

Lock.main_widget = wibox.widget {
	layout = wibox.layout.stack,
	{
		widget = wibox.container.place,
		valign = "top",
		{
			widget = wibox.container.margin,
			top = 40,
			Lock.time,
		}
	},
	{
		widget = wibox.container.place,
		valign = "center",
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 10,
			Lock.header,
			Lock.promptbox,
		}
	}
}

Lock.popup = awful.popup {
	screen = s,
	visible = false,
	ontop = true,
	minimum_height = s.geometry.height,
	minimum_width = s.geometry.width,
	placement = function(d) awful.placement.centered(d) end,
	widget = Lock.main_widget
}


Lock.pass_hide = true

function Lock:toggle_password()
	self.promptbox:get_children_by_id("main")[1]:remove(1)
	if self.pass_hide then
		self.promptbox:get_children_by_id("main")[1]:insert(1, self.prompt_pass)
		self.button.text = ""
	else
		self.promptbox:get_children_by_id("main")[1]:insert(1, self.prompt)
		self.button.text = ""
	end
	self.pass_hide = not self.pass_hide
end

Lock.button:buttons {
	awful.button({}, 1, function()
		Lock:toggle_password()
	end)
}

function Lock:reset()
	self.characters_entered = 0;
	self.prompt.markup = "type..."
end

function Lock:fail()
	self.characters_entered = 0;
	self.prompt.markup = "try again..."
end

function Lock:grabpassword()
	awful.prompt.run {
		hooks = {
			{{}, "Escape", function(_)
					self:reset()
					self:grabpassword()
				end
			}
		},
		keypressed_callback = function(_, key)
			if #key == 1 then
				self.characters_entered = self.characters_entered + 1
				self.prompt.markup = helpers.ui.size_text(string.rep("󰧞", self.characters_entered), 11)
			elseif key == "BackSpace" then
				if self.characters_entered > 1 then
					self.characters_entered = self.characters_entered - 1
					self.prompt.markup = helpers.ui.size_text(string.rep("󰧞", self.characters_entered), 11)
				else
					self.characters_entered = 0
					self.prompt.markup = "type..."
				end
			elseif key == "Tab" then
				self:toggle_password()
			end
		end,
		exe_callback = function(input)
			if self:authenticate(input) then
				self:reset()
				self.popup.visible = false
			else
				self:fail()
				self:grabpassword()
			end
		end,
		textbox = self.prompt_pass,
		bg_cursor = beautiful.bg_alt,
	}
end

function Lock:lockscreen()
	self.popup.visible = true
	self:grabpassword()
	awful.spawn.with_shell("playerctl pause")
end

end)

return Lock
