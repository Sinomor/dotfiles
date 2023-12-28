local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local Lock = require("ui.lock")

local Powermenu = {}

Powermenu.elements = {
	{
		command =  function ()
			awful.spawn("loginctl poweroff")
		end,
		icon = ""},
	{
		command = function ()
			awesome.quit()
		end,
		icon = ""
	},
	{
		command = function ()
			awful.spawn("loginctl reboot")
		end,
		icon = ""
	},
	{
		command = function ()
			Lock:lockscreen()
		end,
		icon = ""
	},
}

Powermenu.main_layout = wibox.widget {
	homogeneous = false,
	expand = true,
	forced_num_cols = 2,
	forced_num_rows = 2,
	spacing = 10,
	layout = wibox.layout.grid
}

Powermenu.prompt = wibox.widget {
	widget = wibox.widget.textbox,
	visible = false
}

Powermenu.main_widget = wibox.widget{
	widget = wibox.container.margin,
	margins = 10,
	{
		layout = wibox.layout.fixed.vertical,
		Powermenu.prompt,
		Powermenu.main_layout
	}
}

Powermenu.popup = awful.popup {
	visible = false,
	ontop = true,
	bg = beautiful.bg,
	border_color = beautiful.border_color_normal,
	border_width = beautiful.border_width,
	placement = function(d)
		awful.placement.centered(d)
	end,
	widget = Powermenu.main_widget
}

function Powermenu:next()
	if self.index_element == 2 then
		self.index_element = self.index_element + 2
	elseif index_element ~= #self.elements then
		self.index_element = self.index_element + 1
	end
end

function Powermenu:back()
	if self.index_element ~= 1 and self.index_element ~= 3 then
		self.index_element = self.index_element - 1
	end
end

function Powermenu:up()
	if self.index_element > 2 then
		self.index_element = self.index_element - 2
	end
end

function Powermenu:down()
	if self.index_element < 3 then
		self.index_element = self.index_element + 2
	end
end

function Powermenu:add_elements()

	self.main_layout:reset()

	for i, element in ipairs(self.elements) do

		local element_widget = wibox.widget {
			widget = wibox.container.background,
			bg = beautiful.bg,
			forced_width = 140,
			forced_height = 140,
			buttons = {
				awful.button({}, 1, function()
					if index_element == i then
						element:command()
					else
						self.index_element = i
						self:add_elements()
					end
				end)
			},
			{
				widget = wibox.widget.textbox,
				fg = beautiful.fg,
				align = "center",
				font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 26),
				markup = element.icon
			}
		}

		self.main_layout:add(element_widget)

		if i == self.index_element then
			element_widget.bg = beautiful.accent
			element_widget.fg = beautiful.bg
		end

	end

end

function Powermenu:run_prompt()
	awful.prompt.run {
		textbox = self.prompt,
		exe_callback = function()
			self.elements[self.index_element]:command()
		end,
		keypressed_callback = function(_, key)
			if key == "Right" or key == "l" then
				self:next()
				self:add_elements()
			elseif key == "Left" or key == "h" then
				self:back()
				self:add_elements()
			elseif key == "Up" or key == "k" then
				self:up()
				self:add_elements()
			elseif key == "Down" or key == "j" then
				self:down()
				self:add_elements()
			end
		end,
		done_callback = function()
			self.popup.visible = false
		end
	}
end

function Powermenu:open()
	self.popup.visible = true
	self.index_element = 1
	self:add_elements()
	self:run_prompt()
end

function Powermenu:close()
	awful.keygrabber.stop()
	self.popup.visible = false
end

function Powermenu:toggle()
	if not self.popup.visible then
		self:open()
	else
		self:close()
	end
end

return Powermenu
