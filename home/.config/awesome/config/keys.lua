local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")
local user = require("user")

local Bright = require("scripts.signals.bright")
local Volume = require("scripts.signals.vol")
local Wall = require("scripts.awesome.wallpapers")

local Launcher = require("ui.launcher")
local Powermenu = require("ui.powermenu")
local Control = require("ui.control")
local Info = require("ui.bar.modules.info")
local Bar = require("ui.bar")
local tray = require("ui.bar.modules.tray")
local Wifi_applet = require("ui.control.main.wifi_applet")

mod = "Mod4"
alt = "Mod1"
ctrl = "Control"
shift = "Shift"

awful.keyboard.append_global_keybindings({

	-- launch programms --

	awful.key({ mod }, "Return", function() awful.spawn(user.terminal) end),
	awful.key({ mod }, "e", function() awful.spawn(user.file_manager) end),
	awful.key({ mod }, "b", function() awful.spawn(user.browser) end),
	awful.key({ mod }, "a", function() awful.spawn("ayugram-desktop" or "telegram-desktop") end),
	awful.key({}, "Print", function() awful.spawn("flameshot gui") end),

	-- some scripts --

	awful.key({ mod, ctrl }, "w", function() Wall:change_wall("Random") end),
	awful.key({ mod, ctrl }, "p", function() awful.spawn.with_shell(user.bins.colorpicker) end),
	awful.key({ mod, ctrl }, "q", function() awful.spawn.with_shell(user.bins.qr_codes) end),

	-- playerctl --

	awful.key({}, "XF86AudioPlay", function()
		awful.spawn.with_shell("playerctl play-pause")
	end),
	awful.key({}, "XF86AudioPrev", function()
		awful.spawn.with_shell("playerctl previous")
	end),
	awful.key({}, "XF86AudioNext", function()
		awful.spawn.with_shell("playerctl next")
	end),

	-- volume up/down/mute --

	awful.key({}, "XF86AudioRaiseVolume", function()
		Volume:change_value("up")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		Volume:change_value("down")
	end),
	awful.key({}, "XF86AudioMute", function()
		Volume:change_value("mute")
	end),

	-- brightness up/down --

	awful.key({}, "XF86MonBrightnessUp", function()
		Bright:change_value("up")
	end),
	awful.key({}, "XF86MonBrightnessDown", function()
		Bright:change_value("down")
	end),

	-- binds to open widgets --

	awful.key({ mod, ctrl }, "b", function() Launcher:open("books") end),
	awful.key({ mod, ctrl }, "c", function() Launcher:open("clipboard") end),
	awful.key({ mod, ctrl }, "a", function() Launcher:open("clients") end),
	awful.key({ mod }, "d", function() Launcher:open() end),
	awful.key({ mod }, "x", function() Powermenu:open() end),
	awful.key({ mod }, "w", function() Wifi_applet:toggle() end),
	awful.key({ mod }, "c", function() Control:toggle("moment") end),
	awful.key({ mod }, "p", function() Control:toggle("main") end),
	awful.key({ mod }, "o", function() Control:toggle("system") end),
	awful.key({ mod }, "i", function() Control:toggle("config") end),

	-- other widgets binds --

	awful.key({ mod }, "m", function() Info:dnd_toggle() end),
	awful.key({ mod, shift }, "b", function() Bar:toggle() end),
	awful.key({ mod }, "t", function() tray:toggle() end),

	-- switching a focus client -- 

	awful.key({ mod }, "l", function () awful.client.focus.byidx(1) end),
	awful.key({ mod }, "h", function () awful.client.focus.byidx(-1) end),

	-- focus to tag --

	awful.key {
		modifiers = { mod },
		keygroup = "numrow",
		on_press = function (index)
		local screen = awful.screen.focused()
		local tag = screen.tags[index]
		if tag then
			tag:view_only()
		end
	end},

	-- move focused client to tag --

	awful.key {
		modifiers = { mod, shift },
		keygroup = "numrow",
		on_press = function (index)
		if client.focus then
			local tag = client.focus.screen.tags[index]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end},

	-- restart wm --

	awful.key({ mod, shift }, "r", awesome.restart),

	-- resize client --

   awful.key({ mod, ctrl }, "k", function(c)
		helpers.client.resize_client(client.focus, "up")
	end),
	awful.key({ mod, ctrl }, "j", function(c)
		helpers.client.resize_client(client.focus, "down")
	end),
	awful.key({ mod, ctrl }, "h", function(c)
		helpers.client.resize_client(client.focus, "left")
	end),
	awful.key({ mod, ctrl }, "l", function(c)
		helpers.client.resize_client(client.focus, "right")
	end),

})

-- mouse binds --

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({ }, 1, function (c)
			c:activate { context = "mouse_click" }
		end),
		awful.button({ mod }, 1, function (c)
			c:activate { context = "mouse_click", action = "mouse_move"  }
		end),
		awful.button({ mod }, 3, function (c)
			c:activate { context = "mouse_click", action = "mouse_resize" }
		end),
	})
end)

-- client binds --

client.connect_signal("request::default_keybindings", function()

	awful.keyboard.append_client_keybindings({
		awful.key({ mod }, "f",
			function (c)
				c.fullscreen = not c.fullscreen
				c:raise()
			end),
		awful.key({ mod }, "q", function (c) c:kill() end),
		awful.key({ mod }, "s", awful.client.floating.toggle),

		awful.key({ mod, shift }, "n", function (c)
				c.minimized = true
		end),

		awful.key({ mod, shift}, "m", function (c)
			c.maximized = not c.maximized
			c:raise()
		end),

		-- Move or swap by direction --

		awful.key({ mod, shift }, "k", function(c)
			helpers.client.move_client(c, "up")
		end),
		awful.key({ mod, shift }, "j", function(c)
			helpers.client.move_client(c, "down")
		end),
		awful.key({ mod, shift }, "h", function(c)
			helpers.client.move_client(c, "left")
		end),
		awful.key({ mod, shift }, "l", function(c)
			helpers.client.move_client(c, "right")
		end),

		--- Relative move  floating client --

		awful.key({ mod, shift, ctrl }, "j", function(c)
			c:relative_move(0, 20, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "k", function(c)
			c:relative_move(0, -20, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "h", function(c)
			c:relative_move(-20, 0, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "l", function(c)
			c:relative_move(20, 0, 0, 0)
		end),

	})

end)

client.connect_signal("button::press", function()
	Launcher:close()
	Powermenu:close()
	Control:close(Control.mode)
end)

awful.mouse.append_global_mousebinding(
	awful.button({}, 1, function()
		Launcher:close()
		Powermenu:close()
		Control:close(Control.mode)
	end)
)

