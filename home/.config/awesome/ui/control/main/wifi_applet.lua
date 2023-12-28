local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local helpers = require("helpers")
local beautiful = require("beautiful")

local wifi_daemon = require("scripts.signals.wifi")

local Wifi = {}
local Sidebar = {}

function Sidebar.creare_button(widget)
	local button = wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		fg = beautiful.fg,
		forced_width = 40,
		forced_height = 40,
		widget
	}
	button:connect_signal("mouse::enter", function()
		helpers.ui.transitionColor {
			old = beautiful.bg_alt,
			new = beautiful.bg_urgent,
			transformer = function(col)
				button.bg = col
			end,
			duration = 0.8
		}
	end)
	button:connect_signal("mouse::leave", function()
		helpers.ui.transitionColor {
			old = beautiful.bg_urgent,
			new = beautiful.bg_alt,
			transformer = function(col)
				button.bg = col
			end,
			duration = 0.8
		}
	end)
	return button
end

Wifi.characters_entered = 0

Sidebar.reveal_button = Sidebar.creare_button({
	widget = wibox.widget.textbox,
	align = "center",
	text = "",
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 4),
})

Sidebar.refresh_button = Sidebar.creare_button({
	widget = wibox.widget.textbox,
	align = "center",
	text = "",
	font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 3),
})

Sidebar.main_widget = wibox.widget {
	widget =  wibox.container.margin,
	margins = { right = 10, bottom = 10, top = 10 },
	{
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		forced_width = 60,
		{
			widget = wibox.container.margin,
			margins = 10,
			{
				layout = wibox.layout.align.vertical,
				Sidebar.refresh_button,
				nil,
				Sidebar.reveal_button
			}
		}
	}
}

Wifi.massage = wibox.widget {
	widget = wibox.container.background,
	fg = beautiful.fg_alt,
	forced_width = 370,
	forced_height = 458,
	{
		widget = wibox.widget.textbox,
		halign = "center",
		valign = "center"
	}
}

Wifi.passbox_prompt = wibox.widget.textbox()
Wifi.passbox_prompt_hide = wibox.widget.textbox()
Wifi.passbox_title = wibox.widget.textbox()

Wifi.hide_button = wibox.widget {
	widget = wibox.widget.textbox,
	text = "",
	halign = "right"
}

Wifi.passbox = wibox.widget {
	widget = wibox.container.background,
	forced_width = 370,
	{
		layout = wibox.layout.fixed.vertical,
		spacing = 10,
		{
			widget = wibox.container.margin,
			margins = 10,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 10,
				{
					widget = wibox.container.background,
					buttons = {
						awful.button({}, 1, function()
							Wifi:close_passbox()
						end)
					},
					{
						widget = wibox.widget.textbox,
						text = "",
						font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 3),
					}
				},
				Wifi.passbox_title
			}
		},
		{
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			{
				widget = wibox.container.margin,
				margins = { left = 20, right = 20, top = 10, bottom = 10 },
				{
					layout = wibox.layout.align.horizontal,
					forced_height = 40,
					{
						widget = wibox.widget.textbox,
						text = "Password: "
					},
					{
						layout = wibox.layout.fixed.horizontal,
						id = "prompt",
						Wifi.passbox_prompt_hide
					},
					Wifi.hide_button,
				}
			}
		}
	}
}

Wifi.pass_hide = true

function Wifi:toggle_password()
	self.passbox:get_children_by_id("prompt")[1]:remove(1)
	if self.pass_hide then
		self.passbox:get_children_by_id("prompt")[1]:insert(1, self.passbox_prompt)
		self.hide_button.text = ""
	else
		self.passbox:get_children_by_id("prompt")[1]:insert(1, self.passbox_prompt_hide)
		self.hide_button.text = ""
	end
	self.pass_hide = not self.pass_hide
end

Wifi.hide_button:buttons {
	awful.button({}, 1, function()
		Wifi:toggle_password()
	end)
}

Wifi.active_container = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	forced_width = 370
}

Wifi.separator = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.bg_alt,
	forced_height = beautiful.border_width,
}

Wifi.container = wibox.widget {
	layout = wibox.layout.overflow.vertical,
	scrollbar_enabled = false,
	step = 60,
	spacing = 10,
	forced_width = 370
}

Wifi.main_layout = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = 10
}

Wifi.main_widget = wibox.widget {
	widget = wibox.container.background,
	{
		layout = wibox.layout.fixed.horizontal,
		{
			widget = wibox.container.margin,
			margins = 10,
			{
				layout = wibox.layout.fixed.vertical,
				Wifi.main_layout
			}
		},
		Sidebar.main_widget
	}
}

Wifi.popup = awful.popup {
	visible = false,
	ontop = true,
	border_width = beautiful.border_width,
	border_color = beautiful.border_color_normal,
	minimum_width = 460,
	maximum_width = 460,
	minimum_height = 478,
	maximum_height = 478,
	placement = function(d)
		awful.placement.centered(d, { honor_workarea = true })
	end,
	widget = Wifi.main_widget,
}

function Wifi:add_entries(list)
	self.container:reset()
	self.active_container:reset()
	self.main_layout:reset()
	self.main_layout:add(self.active_container, self.separator, self.container)
	for _, entry in ipairs(list) do
		local entry_info = wibox.widget {
			widget = wibox.widget.textbox
		}
		local wifi_entry = wibox.widget {
			widget = wibox.container.background,
			forced_height = 50,
			{
				widget = wibox.container.margin,
				margins = 10,
				{
					layout = wibox.layout.align.horizontal,
					{
						widget = wibox.widget.textbox,
						text = entry.ssid
					},
					nil,
					entry_info
				}
			}
		}

		if entry.active == "yes" then
			entry_info.text = ""
			self.active_container:add(wifi_entry)
		elseif entry.active:match("no") then
			if entry.security:match("WPA") then
				entry_info.text = ""
			else
				entry_info.text = ""
			end
			wifi_entry.buttons = {
				awful.button({}, 1, function()
					Wifi:enter_passwd(entry.ssid, entry.bssid, entry.security)
				end)
			}
			self.container:add(wifi_entry)
		end
	end
end

function Wifi:enter_passwd(ssid, bssid, security)
	self.passbox.state = true
	self.main_layout:reset()
	self.main_layout:add(self.passbox)
	self.passbox_title.text = ssid
	awful.prompt.run {
		textbox = self.passbox_prompt,
		bg_cursor = beautiful.bg_alt,
		hooks = {
			{{}, "Escape", function(_)
				self.pass_hide = true
				self.characters_entered = 0
				self.passbox_prompt_hide.markup = ""
				self:close_passbox()
			end
		}
	},
	keypressed_callback = function(_, key)
		if #key == 1 then
			self.characters_entered = self.characters_entered + 1
			self.passbox_prompt_hide.markup = helpers.ui.size_text(string.rep("󰧞", self.characters_entered), 11)
		elseif key == "BackSpace" then
			if self.characters_entered > 1 then
				self.characters_entered = self.characters_entered - 1
				self.passbox_prompt_hide.markup = helpers.ui.size_text(string.rep("󰧞", self.characters_entered), 11)
			else
				self.characters_entered = 0
				self.passbox_prompt_hide.markup = ""
			end
		elseif key == "Tab" then
			self:toggle_password()
		end
	end,
	done_callback = function()
		self.main_layout:reset()
		self.main_layout:add(self.active_container, self.separator, self.container)
	end,
	exe_callback = function(input)
		wifi_daemon:connect(ssid, bssid, security, input)
		Wifi:refresh()
	end
}
awesome.emit_signal("wifi::keygrubber")
end

function Wifi:close_passbox()
	self.passbox.state = false
	awful.keygrabber.stop()
	self.main_layout:reset()
	self.main_layout:add(self.active_container, self.separator, self.container)
end

function Wifi:refresh()
	self.container:reset()
	self.active_container:reset()
	wifi_daemon:get_status()
end

awesome.connect_signal("wifi:status", function(status)
	if not status then
		Wifi.massage.widget.text = "Wifi disabled"
		Wifi.main_layout:reset()
		Wifi.main_layout:add(Wifi.massage)
	end
end)

awesome.connect_signal("wifi:scan_started", function()
	Wifi.main_layout:reset()
	Wifi.main_layout:add(Wifi.massage)
	Wifi.massage.widget.text = "Please wait..."
end)

awesome.connect_signal("wifi:scan_finished", function(wifi_list)
	Wifi:add_entries(wifi_list)
end)

Sidebar.reveal_button:buttons {
	awful.button({}, 1, function()
		Wifi:close()
	end)
}

Sidebar.refresh_button:buttons {
	awful.button({}, 1, function()
		Wifi:refresh()
	end)
}

-- summon functions --

function Wifi:open()
	self.popup.visible = not self.popup.visible
	self.characters_entered = 0
	self.pass_hide = true
end

function Wifi:close()
	self.popup.visible = false
	self:close_passbox()
end

function Wifi:toggle()
	if self.popup.visible then
		self:close()
	else
		self:open()
	end
end

return Wifi
