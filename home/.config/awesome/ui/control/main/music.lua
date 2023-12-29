local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local user = require("user")
local helpers = require("helpers")
local bling = require("modules.bling")
local playerctl = bling.signal.playerctl.lib()
local gears = require("gears")

local Music = {}

Music.art = wibox.widget {
	image = beautiful.no_song,
	opacity = 0.8,
	resize = true,
	valign = "center",
	halign = "center",
	horizontal_fit_policy = "cover",
	vertical_fit_policy = "cover",
	widget = wibox.widget.imagebox
}

Music.title = wibox.widget {
	markup = "Nothing Playing",
	halign = "left",
	widget = wibox.widget.textbox
}

Music.artist = wibox.widget {
	halign = "left",
	widget = wibox.widget.textbox
}

function Music:create_music_button(text, func)
	local widget = wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_urgent,
		{
			widget = wibox.container.margin,
			margins = 5,
			{
				widget = wibox.widget.textbox,
				id = "icon",
				markup = text,
				font = beautiful.font_name .. " " .. tostring(beautiful.font_size + 5),
			}
		}
	}
	widget:buttons {
		awful.button({}, 1, function()
			func()
		end)
	}
	return widget
end

Music.next = Music:create_music_button("", function() playerctl:next() end)
Music.prev = Music:create_music_button("", function() playerctl:previous() end)
Music.play = Music:create_music_button("", function() playerctl:play_pause() end)

Music.media_slider = wibox.widget {
	widget = wibox.widget.slider,
	bar_color = beautiful.bg_urgent,
	bar_active_color = beautiful.yellow,
	handle_width = 0,
	minimum = 0,
	maximum = 100,
	value = 0
}

Music.previous_value = 0
Music.internal_update = false

Music.media_slider:connect_signal("property::value", function(_, new_value)
	if Music.internal_update and new_value ~= Music.previous_value then
		Music.playerctl:set_position(new_value)
		Music.previous_value = new_value
	end
end)

playerctl:connect_signal("position", function(_, interval_sec, length_sec)
	Music.internal_update = true
	Music.previous_value = interval_sec
	Music.media_slider.value = interval_sec
end)

awful.spawn.with_line_callback("playerctl -F metadata -f '{{mpris:length}}'", {
	stdout = function(line)
		if line == "" then
			local position = 100
			Music.media_slider.maximum = position
		else
			local position = tonumber(line)
			if position ~= nil then
				Music.media_slider.maximum = position / 1000000 or nil
			end
		end
	end
})

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	if album_path == "" then
		Music.art:set_image(beautiful.no_song)
	else
		Music.art:set_image(gears.surface.load_uncached(album_path))
	end
	Music.title:set_markup_silently(title)
	Music.artist:set_markup_silently(artist)
	collectgarbage("collect")
end)

Music.main_widget = wibox.widget {
	widget = wibox.container.background,
	forced_height = 140,
	forced_width = 470,
	bg = beautiful.bg_alt,
	{
		layout = wibox.layout.stack,
		Music.art,
		{
			widget = wibox.container.background,
			bg = {
				type = "linear",
				from = { 0, 0 },
				to = { 460, 0 },
				stops = {
					{ 0.1, beautiful.bg_alt },
					{ 0.3, beautiful.bg_alt .. "E6" },
					{ 0.5, beautiful.bg_alt .. "CC" },
					{ 0.7, beautiful.bg_alt .. "B3" },
					{ 0.9, beautiful.bg_alt .. "99" } }
				}
			},
			{
				widget = wibox.container.margin,
				margins = 10,
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = 20,
					{
						widget = wibox.container.rotate,
						direction = "east",
						forced_width = beautiful.border_width * 4,
						Music.media_slider
					},
					{
						layout = wibox.layout.flex.vertical,
						{
							layout = wibox.layout.fixed.vertical,
							spacing = 10,
							{
								widget = wibox.container.scroll.horizontal,
								step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
								speed = 50,
								Music.title
							},
							Music.artist
						},
						{
							widget = wibox.container.place,
							valign = "bottom",
							halign = "left",
							{
								layout = wibox.layout.fixed.horizontal,
								spacing = 15,
								Music.prev,
								Music.play,
								Music.next
							}
						}
					}
				}
			}
		}
	}
	if not user.control_fullscreen then
		Music.main_widget.forced_height = 180
	end

	playerctl:connect_signal("playback_status", function(_, playing, player_name)
		Music.play:get_children_by_id("icon")[1].markup = playing and
		helpers.ui.colorizeText("", "") or helpers.ui.colorizeText("", "")
	end)

	return Music
