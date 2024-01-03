local awful = require("awful")
local wibox = require("wibox")
local lgi = require("lgi")
local Gio = lgi.Gio
local beautiful = require("beautiful")
local helpers = require("helpers")
local user = require("user")
local gears = require("gears")
local dir = "~/.disk/Books/'10 класс'/"

local Powermenu = require("ui.powermenu")
local Launcher = {}
local Tabbar = {}

-- bar module --

local Bar = require("ui.bar")
local launcher = require("ui.bar.mods.launcher")
launcher.text:buttons {
	awful.button({}, 1, function()
		Launcher:toggle()
	end)
}

-- launcher --

if user.launcher_fullscreen then
	Launcher.entries_count = 13
else
	Launcher.entries_count = 6
end

Tabbar.elems = {
	{ name = "launcher", icon = "", index = 1 },
	{ name = "clipboard", icon = "", index = 2 },
	{ name = "books", icon = "", index = 3 },
	{ name = "clients", icon = "", index = 4 }
}

if user.launcher_fullscreen then
	Tabbar.e_container = wibox.widget {
		homogeneous = false,
		expand = false,
		forced_num_cols = 4,
		spacing = 10,
		layout = wibox.layout.grid
	}
else
	Tabbar.e_container = wibox.widget {
		homogeneous = false,
		expand = false,
		forced_num_rows = 4,
		spacing = 10,
		layout = wibox.layout.grid
	}
end

function Tabbar:next_el()
	if self.el_index > 1 then
		self.el_index = self.el_index - 1
		Launcher:change_mode(Tabbar.elems[self.el_index].name)
	end
end

function Tabbar:prev_el()
	if self.el_index < 4 then
		self.el_index = self.el_index + 1
		Launcher:change_mode(Tabbar.elems[self.el_index].name)
	end
end

function Tabbar:add_modes()
	Tabbar.e_container:reset()

	for i, el in ipairs(self.elems) do
		local el_widget = wibox.widget {
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			forced_width = 40,
			forced_height = 40,
			buttons = {
				awful.button({}, 1, function()
					if self.el_index ~= i then
						Launcher:change_mode(el.name)
					end
				end),
				awful.button({}, 4, function()
					self:next_el()
				end),
				awful.button({}, 5, function()
					self:prev_el()
				end)
			},
			{
				widget = wibox.widget.textbox,
				fg = beautiful.fg,
				align = "center",
				font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 3),
				markup = el.icon
			}
		}

		Tabbar.e_container:add(el_widget)

		if i == self.el_index then
			helpers.ui.transitionColor {
				old = beautiful.bg_alt,
				new = beautiful.bg_urgent,
				transformer = function(col)
					el_widget.bg = col
				end,
				duration = 0.8
			}
		end
	end
end

Tabbar.power_button = wibox.widget {
	widget = wibox.container.background,
	forced_height = 40,
	forced_width = 40,
	{
		widget = wibox.widget.textbox,
		markup = helpers.ui.colorizeText("", beautiful.red),
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 3),
		halign = "center"
	}
}

Tabbar.power_button:buttons {
	awful.button({}, 1, function()
		Powermenu:toggle()
		Launcher:toggle()
	end)
}

Tabbar.power_button:connect_signal("mouse::enter", function()
	helpers.ui.transitionColor {
		old = beautiful.bg_alt,
		new = beautiful.bg_urgent,
		transformer = function(col)
			Tabbar.power_button.bg = col
		end,
		duration = 0.8
	}
end)

Tabbar.power_button:connect_signal("mouse::leave", function()
	helpers.ui.transitionColor {
		old = beautiful.bg_urgent,
		new = beautiful.bg_alt,
		transformer = function(col)
			Tabbar.power_button.bg = col
		end,
		duration = 0.8
	}
end)

Tabbar.main_widget = {
	widget = wibox.container.background,
	bg = beautiful.bg_alt,
	{
		widget = wibox.container.margin,
		margins = 10,
		{
			layout = user.launcher_fullscreen and wibox.layout.align.horizontal or wibox.layout.align.vertical,
			Tabbar.e_container,
			nil,
			Tabbar.power_button
		}
	}
}
if user.launcher_fullscreen then
	Tabbar.main_widget.forced_height = 60
else
	Tabbar.main_widget.forced_width = 60
end

Launcher.prompt = wibox.widget.textbox()

Launcher.promptbox = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.border_color,
	forced_height = 60,
	buttons = {
		awful.button({}, 1, function()
			Launcher:run_prompt()
		end)
	},
	{
		widget = wibox.container.background,
		bg = beautiful.border_color_normal,
		{
			widget = wibox.container.margin,
			bottom = beautiful.border_width,
			{
				widget = wibox.container.background,
				bg = beautiful.bg,
				Launcher.prompt
			}
		}
	}
}

Launcher.entries_container = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = 10,
	forced_height = 60 * (Launcher.entries_count + 1) + 10 * (Launcher.entries_count),
}
if user.launcher_fullscreen then
	Launcher.entries_container.forced_width = 470
else
	Launcher.entries_container.forced_width = 420
end
Launcher.main_widget = wibox.widget {
	widget = wibox.container.margin,
	margins = user.launcher_fullscreen and 20 or 10,
	{
		layout = user.launcher_fullscreen and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal,
		spacing = 10,
		Launcher.entries_container,
		Tabbar.main_widget
	}
}

if user.launcher_fullscreen then
	Launcher.popup = awful.popup {
		ontop = true,
		visible = false,
		minimum_height = screen[1].geometry.height,
		minimum_width = 510 + beautiful.border_width,
		maximum_width = 510 + beautiful.border_width,
		placement = function(d) awful.placement.right(d) end,
		widget = wibox.widget {
			widget = wibox.container.background,
			bg = beautiful.border_color_normal,
			{
				widget = wibox.container.margin,
				left = beautiful.border_width,
				{
					widget = wibox.container.background,
					bg = beautiful.bg,
					Launcher.main_widget
				}
			}
		}
	}
else
	Launcher.popup = awful.popup {
		ontop = true,
		visible = false,
		minimum_height = 60 * (Launcher.entries_count + 1) + 10 * Launcher.entries_count + 20,
		maximum_height = 60 * (Launcher.entries_count + 1) + 10 * Launcher.entries_count + 20,
		minimum_width = 510 + beautiful.border_width,
		maximum_width = 510 + beautiful.border_width,
		border_width = beautiful.border_width,
		border_color = beautiful.border_color_normal,
		widget = Launcher.main_widget
	}
end

function Launcher:next()
	if self.index_entry ~= #self.filtered and #self.filtered > 1 then
		self.index_entry = self.index_entry + 1
		if self.index_entry > self.index_start + Launcher.entries_count - 1 then
			self.index_start = self.index_start + 1
		end
	else
		self.index_entry = 1
		self.index_start = 1
	end
end

function Launcher:back()
	if self.index_entry ~= 1 and #self.filtered > 1 then
		self.index_entry = self.index_entry - 1
		if self.index_entry < self.index_start then
			self.index_start = self.index_start - 1
		end
	else
		self.index_entry = #self.filtered
		if #self.filtered < Launcher.entries_count then
			self.index_start = 1
		else
			self.index_start = #self.filtered - Launcher.entries_count + 1
		end
	end
end

function Launcher:get_apps()
	local entries = {}
	for _, entry in ipairs(Gio.AppInfo.get_all()) do
		if entry:should_show() then
			local name = entry:get_name():gsub("&", "&amp;"):gsub("<", "&lt;"):gsub("'", "&#39;")
			table.insert(entries, { name = name, appinfo = entry })
		end
	end
	return entries
end

function Launcher:get_clients()
	local entries = {}
	for _, c in ipairs(client.get()) do
		table.insert( entries, { name = c.name, client = c, max = c.maximized, min = c.minimized })
	end
	return entries
end

function Launcher:get_books()
	local entries = {}
	awful.spawn.easy_async_with_shell("ls -1 " .. dir, function(stdout, stderr, reason, code)
		for line in stdout:gmatch("[^\n]+") do
			local exe_command = "cd " .. dir .. " && zathura " .. line
			table.insert(entries, { name = line, appinfo = exe_command  })
		end
		if reason == "exit" then
			awesome.emit_signal("get_books::finished", entries)
		end
	end)
end

awesome.connect_signal("get_books::finished", function(entries)
	Launcher.unfiltered = entries
	Launcher:filter("")
	Launcher:add_entries("")
end)

function Launcher:get_clipboard()
	local entries = {}
	awful.spawn.easy_async_with_shell(user.bins.greenclip .. " print", function(stdout, stderr, reason, code)
		for line in stdout:gmatch("[^\n]+") do
			local exe_command = "echo " .. "'" .. line .. "'" .. " | xclip -selection c"
			table.insert(entries, { name = line, appinfo = exe_command })
		end
		if reason == "exit" then
			awesome.emit_signal("get_clipboard::finished", entries)
		end
	end)
end

awesome.connect_signal("get_clipboard::finished", function(entries)
	Launcher.unfiltered = entries
	Launcher:filter("")
	Launcher:add_entries("")
end)

function Launcher:filter(input)
	local clear_input = input:gsub("[%(%)%[%]%%]", "")

	self.filtered = {}
	self.regfiltered = {}

	for _, entry in ipairs(self.unfiltered) do
		if entry.name:lower():sub(1, clear_input:len()) == clear_input:lower() then
			table.insert(self.filtered, entry)
		elseif entry.name:lower():match(clear_input:lower()) then
			table.insert(self.regfiltered, entry)
		end
	end
	if self.mode ~= "clipboard" then
		table.sort(self.filtered, function(a, b) return a.name:lower() < b.name:lower() end)
		table.sort(self.regfiltered, function(a, b) return a.name:lower() < b.name:lower() end)
	end

	for i = 1, #self.regfiltered do
		self.filtered[#self.filtered + 1] = self.regfiltered[i]
	end

end

function Launcher:add_entries(input)
	self.entries_container:reset()
	self.entries_container:add(self.promptbox)

	if self.index_entry > #self.filtered and #self.filtered ~= 0 then
		self.index_start, self.index_entry = 1, 1
	elseif self.index_entry < 1 then
		self.index_entry, self.index_start = 1, 1
	end

	for i, entry in ipairs(self.filtered) do
		local entry_widget = wibox.widget {
			forced_height = 60,
			buttons = {
				awful.button({}, 1, function()
					if self.index_entry == i then
						if self.mode == nil then
							entry.appinfo:launch()
						elseif self.mode == "clients" then
							awful.client.jumpto(entry.client)
						else
							awful.spawn.with_shell(entry.appinfo)
						end
						self:close()
					else
						self.index_entry = i
						self:filter(input)
						self:add_entries(input)
					end
				end),
				awful.button({}, 4, function()
					self:back()
					self:filter(input)
					self:add_entries(input)
				end),
				awful.button({}, 5, function()
					self:next()
					self:filter(input)
					self:add_entries(input)
				end),
			},
			widget = wibox.container.background,
			{
				margins = 10,
				widget = wibox.container.margin,
				{
					text = entry.name,
					widget = wibox.widget.textbox,
				}
			}
		}

		if self.index_start <= i and i <= self.index_start + Launcher.entries_count - 1 then
			self.entries_container:add(entry_widget)
		end

		if i == self.index_entry then
			entry_widget.bg = beautiful.accent
			entry_widget.fg = beautiful.bg
		end
	end
	collectgarbage("collect")
end

function Launcher:send_signal()
	awesome.emit_signal("launcher:state", self.state)
end

function Launcher:run_prompt()
	awful.prompt.run {
		prompt = "Search: ",
		textbox = self.prompt,
		bg_cursor = beautiful.bg_alt,
		fg_cursor = beautiful.fg,
		done_callback = function()
			self:close()
		end,
		changed_callback = function(input)
			self:filter(input)
			self:add_entries(input)
		end,
		exe_callback = function(input)
			if self.filtered[self.index_entry] then
				if self.mode == "launcher" then
					self.filtered[self.index_entry].appinfo:launch()
				elseif self.mode == "clients" then
					awful.client.jumpto(self.filtered[self.index_entry].client)
				else
					awful.spawn.with_shell(self.filtered[self.index_entry].appinfo)
				end
			else
				awful.spawn.with_shell(input)
			end
		end,
		keypressed_callback = function(_, key)
			if key == "Down" then
				self:next()
			elseif key == "Up" then
				self:back()
			elseif key == "Tab" then
				Tabbar.el_index = Tabbar.el_index + 1
				if Tabbar.el_index <= 4 then
					Launcher:change_mode(Tabbar.elems[Tabbar.el_index].name)
				else
					Launcher:change_mode()
				end
			end
		end
	}
end

function Launcher:change_mode(mode)
	if not self.state then return end
	self.state = false
	Launcher.entries_container:reset()
	Tabbar.e_container:reset()
	Launcher:open(mode)
end

function Launcher:open(mode)
	if self.state then return end
	self.state = true
	if self.state then
		Bar:change_bg_container(launcher.widget, "on")
		if user.bar_pos == "Left" and user.launcher_fullscreen then
			self.popup.placement = function(d)
				awful.placement.right(d)
			end
		elseif (user.bar_pos == "Left" or user.bar_pos == "Top") and not user.launcher_fullscreen then
			self.popup.placement = function(d)
				awful.placement.top_left(d, { honor_workarea = true, margins = beautiful.useless_gap*2 })
			end
		elseif user.bar_pos == "Right" and not user.launcher_fullscreen then
			self.popup.placement = function(d)
				awful.placement.top_right(d, { honor_workarea = true, margins = beautiful.useless_gap*2 })
			end
		elseif user.bar_pos == "Bottom" and not user.launcher_fullscreen then
			self.popup.placement = function(d)
				awful.placement.bottom_left(d, { honor_workarea = true, margins = beautiful.useless_gap*2 })
			end
		elseif user.bar_pos == "Right" and user.launcher_fullscreen then
			self.popup.placement = function(d)
				awful.placement.left(d)
			end
		end
		self.popup.visible = true
	end

	mode = mode or "launcher"
	self.mode = mode
	self.index_start, self.index_entry = 1, 1
	if self.mode == "launcher" then
		self.unfiltered = self:get_apps()
		Tabbar.el_index = 1
	elseif mode == "clipboard" then
		self:get_clipboard()
		Tabbar.el_index = 2
	elseif mode == "books" then
		self:get_books()
		Tabbar.el_index = 3
	elseif mode == "clients" then
		self.unfiltered = self:get_clients()
		Tabbar.el_index = 4
	end
	Tabbar:add_modes()

	self:send_signal()

	if self.mode ~= ("clipboard" or "books") then
		self:filter("")
		self:add_entries("")
	end

	awful.keygrabber.stop()
	self:run_prompt()
end

function Launcher:close()
	if not self.state then return end
	self.state = false

	Bar:change_bg_container(launcher.widget, "off")
	awful.keygrabber.stop()
	self.popup.visible = false
	self:send_signal()
end

function Launcher:toggle(mode)
	if not self.popup.visible then
		self:open(mode)
	else
		self:close()
	end
end


return Launcher
