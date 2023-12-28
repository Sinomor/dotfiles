local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local rubato = require("modules.rubato")
local helpers = require("helpers")
local user = require("user")
local Top = require("scripts.signals.top")

local System = {}

-- arcchart --

function System:create_arcchart(signal, bg, fg, thickness, text, icon)

	local progressbar = wibox.widget {
		widget = wibox.container.arcchart,
		max_value = 100,
		forced_height = 110,
		forced_width = 110,
		min_value = 0,
		thickness = thickness,
		bg = bg,
		colors = { fg }
	}

	local progressbar_icon = wibox.widget {
		widget = wibox.widget.textbox,
		font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 7),
		text = icon,
		halign = "center",
		valign = "center",
	}

	local txt = wibox.widget {
		widget = wibox.widget.textbox,
		text = text,
		halign = "left"
	}

	local value = wibox.widget {
		widget = wibox.widget.textbox,
		halign = "right"
	}

	local widget = wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		forced_width = 150,
		forced_height = 160,
		{
			widget = wibox.container.margin,
			margins = 10,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 10,
				{
					layout = wibox.layout.stack,
					progressbar,
					progressbar_icon,
				},
				{
					layout = wibox.layout.flex.horizontal,
					txt,
					value
				}
			}
		}
	}

	awesome.connect_signal(signal, function(stdout)
		progressbar.value = stdout
		value.text = stdout.. "%"
	end)

	return widget
end

System.resourses = wibox.widget {
	layout = wibox.layout.fixed.horizontal,
	spacing = 10,
	System:create_arcchart("signal::cpu", beautiful.bg_urgent, beautiful.red, 15, "Cpu:", ""),
	System:create_arcchart("signal::ram", beautiful.bg_urgent, beautiful.yellow, 15, "Ram:", ""),
	System:create_arcchart("signal::disk", beautiful.bg_urgent, beautiful.blue, 15, "Disk:", ""),
}

-- profile --

function System:create_fetch_comp(icon, func)
	local comp_text = wibox.widget {
		widget = wibox.widget.textbox,
		id = "text",
		halign = "right"
	}
	local comp_icon = wibox.widget {
		widget = wibox.widget.textbox,
		text = icon,
	}
	local widget = wibox.widget {
		widget = wibox.container.place,
		halign = "right",
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = 20,
			comp_text,
			comp_icon,
		}
	}
	awful.spawn.easy_async_with_shell(func, function(stdout)
		comp_text.text = stdout
	end)
	return widget
end

System.fetch = wibox.widget {
	layout = wibox.layout.flex.vertical,
	forced_width = 310,
	spacing = 12,
	System:create_fetch_comp("", [[ bash -c '. /etc/os-release && echo $PRETTY_NAME' ]]),
	System:create_fetch_comp("", [[ uname -r ]]),
	System:create_fetch_comp("", [[ xbps-query -l | wc -l ]]),
	System:create_fetch_comp("", [[ echo Awesome WM ]]),
}

System.profile_img = wibox.widget {
	widget = wibox.widget.imagebox,
	forced_width = 90,
	forced_height = 90,
	image = beautiful.profile_image,
}
if not user.control_fullscreen then
	System.profile_img.forced_width = 110
	System.profile_img.forced_height = 110
end

System.profile_name = wibox.widget {
	widget = wibox.widget.textbox,
	text = "@" .. user.name:gsub("^%l", string.upper)
}

System.line = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.green,
	forced_width = beautiful.border_width * 4,
}

System.profile = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.bg_alt,
	forced_height = 140,
	{
		widget = wibox.container.margin,
		margins = 10,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = 20,
			{
				layout = wibox.layout.fixed.vertical,
				spacing = 10,
				System.profile_img,
				System.profile_name,
			},
			System.fetch,
			System.line,
		}
	}
}
if not user.control_fullscreen then
	System.profile.forced_height = 160
	System.profile.forced_width = 470
end

-- top --

System.top_container = wibox.widget {
	spacing = 8,
	scrollbar_enabled = false,
	forced_height = 250,
	step = 60,
	layout = wibox.layout.overflow.vertical,
}

System.top_header = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.bg_urgent,
	forced_height = 40,
	{
		widget = wibox.container.margin,
		margins = { left = 10, right = 10 },
		{
			layout = wibox.layout.align.horizontal,
			spacing = 10,
			{
				widget = wibox.widget.textbox,
				forced_width = 240,
				markup = helpers.ui.colorizeText("Name", beautiful.blue)
			},
			{
				layout = wibox.layout.fixed.horizontal,
				forced_width = 110,
				spacing = 4,
				{
					widget = wibox.widget.textbox,
					markup = helpers.ui.colorizeText("Cpu", beautiful.red)
				},
				{
					widget = wibox.widget.textbox,
					markup = helpers.ui.colorizeText("/", beautiful.fg_alt)
				},
				{
					widget = wibox.widget.textbox,
					markup = helpers.ui.colorizeText("Ram", beautiful.yellow)
				},
			},
			{
				widget = wibox.widget.textbox,
				markup = helpers.ui.colorizeText("Pid", beautiful.green)
			}
		}
	}
}

System.top_widget = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.bg_alt,
	{
		widget = wibox.container.margin,
		margins = 20,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 10,
			id = "top_comp",
			System.top_header,
			{
				widget = wibox.container.margin,
				margins = { right = 8, left = 8 },
				System.top_container,
			}
		}
	}
}

function System:top_massange(name, pid)
	local massange = wibox.widget {
		widget = wibox.container.background,
		forced_height = 40,
		bg = beautiful.bg_urgent,
		{
			widget = wibox.container.margin,
			margins = { right = 10, left = 10},
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = 20,
				{
					widget = wibox.widget.textbox,
					markup = "Kill " .. name ..  "?"
				},
				{
					widget = wibox.widget.textbox,
					id = "button_yes",
					markup = helpers.ui.colorizeText("Yes", beautiful.green),
				},
				{
					widget = wibox.widget.textbox,
					id = "button_no",
					markup = helpers.ui.colorizeText("No", beautiful.red),
				}
			}
		}
	}
	massange:get_children_by_id("button_no")[1]:buttons {
		awful.button({}, 1, function()
			self.top_widget:get_children_by_id("top_comp")[1]:remove(3)
			self.top_container.forced_height = 250
		end)
	}
	massange:get_children_by_id("button_yes")[1]:buttons {
		awful.button({}, 1, function()
			awful.spawn.with_shell("kill " .. pid)
			Top.gen_top_list()
			self.top_widget:get_children_by_id("top_comp")[1]:remove(3)
			self.top_container.forced_height = 250
		end)
	}
	return massange
end

awesome.connect_signal("signal::top", function(list)
	System.top_container:reset()
	for _, process in ipairs(list) do
		local process_widget = wibox.widget {
			widget = wibox.container.background,
			bg = beautiful.bg_alt,
			forced_height = 36,
			buttons = {
				awful.button({}, 1, function()
					System.top_widget:get_children_by_id("top_comp")[1]:insert(3, System:top_massange(process.name, process.pid))
					System.top_container.forced_height = 200
				end),
			},
			{
				layout = wibox.layout.align.horizontal,
				{
					widget = wibox.widget.textbox,
					forced_width = 240,
					markup = process.name
				},
				{
					layout = wibox.layout.fixed.horizontal,
					forced_width = 110,
					spacing = 4,
					{
						widget = wibox.widget.textbox,
						markup = process.cpu
					},
					{
						widget = wibox.widget.textbox,
						markup = helpers.ui.colorizeText("/", beautiful.fg_alt)
					},
					{
						widget = wibox.widget.textbox,
						markup = process.mem
					},
				},
				{
					widget = wibox.widget.textbox,
					markup = process.pid
				}
			}
		}

		System.top_container:add(process_widget)
	end
end)

-- disk --

System.disk_container = wibox.widget {
	spacing = 8,
	scrollbar_enabled = false,
	forced_height = 210,
	step = 60,
	layout = wibox.layout.overflow.vertical,
}
if not user.control_fullscreen then
	System.disk_container.forced_height = 250
end

System.disk_header = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.bg_urgent,
	forced_height = 40,
	{
		widget = wibox.container.margin,
		margins = { left = 10, right = 10 },
		{
			layout = wibox.layout.align.horizontal,
			{
				widget = wibox.widget.textbox,
				align = "left",
				markup = "Dir"
			},
			nil,
			{
				widget = wibox.widget.textbox,
				align = "left",
				markup = "Size"
			}
		}
	}
}

System.disk_widget = wibox.widget {
	widget = wibox.container.background,
	bg = beautiful.bg_alt,
	{
		widget = wibox.container.margin,
		margins = 20,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 10,
			System.disk_header,
			{
				widget = wibox.container.margin,
				margins = { right = 8, left = 8 },
				System.disk_container,
			}
		}
	}
}

awesome.connect_signal("signal::disk_list", function(list)
	System.disk_container:reset()
	for _, element in ipairs(list) do
		local element_widget = wibox.widget {
			widget = wibox.container.background,
			forced_height = 36,
			buttons = {
				awful.button({}, 1, function()
					awful.spawn.with_shell("thunar " .. element.dir)
				end),
			},
			{
				layout = wibox.layout.align.horizontal,
				{
					widget = wibox.widget.textbox,
					align = "left",
					markup = element.dir
				},
				nil,
				{
					widget = wibox.widget.textbox,
					align = "left",
					markup = element.size
				}
			}
		}
		System.disk_container:add(element_widget)
	end
end)

-- system --

if user.control_fullscreen then
	System.main_widget = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		spacing = 10,
		System.profile,
		System.resourses,
		System.disk_widget,
		System.top_widget,
	}
else
	System.main_widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = 10,
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 10,
			System.profile,
			System.disk_widget,
		},
		{
			layout = wibox.layout.fixed.vertical,
			spacing = 10,
			System.resourses,
			System.top_widget,
		}
	}
end

return System
