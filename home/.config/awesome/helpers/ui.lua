local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local Color = require("modules.lua-color")
local rubato = require("modules.rubato")

local _ui = {}

function _ui.rrect(radius)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, radius)
	end
end

function _ui.recolor_image(image, color)
	if not image then return end
	if not color then color = beautiful.foreground end
	os.execute("convert " .. image .. " -alpha extract -background '" .. color .. "' -alpha shape -define png:color-type=6 " .. image)
end

function _ui.colorizeText(txt, fg)
	if not fg then fg = beautiful.fg end
	return "<span foreground='" .. fg .. "'>" .. txt .. "</span>"
end

function _ui.size_text(txt, size)
	return "<span size='" .. size .. "pt'>" .. txt .. "</span>"
end

function _ui.create_point(color, size)
	return wibox.widget {
		widget = wibox.container.background,
		bg = color,
		forced_width = size,
		forced_height = size,
	}
end

function _ui.transitionColor(opts)
	local old = Color(opts.old)
	local new = Color(opts.new)
	local animator = rubato.timed {
		duration = opts.duration,
		rate = 60,
		override_dt = false,
		subscribed = function(perc)
			opts.transformer(tostring(old:mix(new, perc / 100)))
		end,
		easing = opts.easing or rubato.quadratic
	}
	animator.target = 100
end

function _ui.get_index(array, value)
	for i, v in ipairs(array) do
		if v == value then
			return i
		end
	end
	return nil
end

return _ui
