local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local rubato = require("modules.rubato")

local T = {}

function T:create_taglist(s)

	self.taglist = awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({ }, 1, function(t) t:view_only() end),
			awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
			awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
		},
		layout = {
			spacing = 8,
			layout = wibox.layout.fixed.vertical
		},
		widget_template = {
			id = "background_role",
			forced_height = 20,
			widget = wibox.container.background,
			create_callback = function(self, tag)
				self.animate = rubato.timed {
					duration = 0.3,
					easing = rubato.easing.linear,
					subscribed = function(h)
						self:get_children_by_id("background_role")[1].forced_height = h
					end
				}
				self.update = function()
					if tag.selected then
						self.animate.target = 40
					elseif #tag:clients() > 0 then
						self.animate.target = 20
					else
						self.animate.target = 20
					end
				end
				self.update()
			end,
			update_callback = function(self)
				self.update()
			end,
		},
	}

	self.taglist_widget = wibox.widget {
		widget = wibox.container.background,
		bg = beautiful.bg_alt,
		forced_height = 208,
		{
			widget = wibox.container.margin,
			margins = 14,
			self.taglist
		}
	}

	return self.taglist_widget

end

function T:create_v(s)
	return self:create_taglist(s)
end

function T:create_h(s)
	self.widget = wibox.widget {
		widget = wibox.container.rotate,
		direction = "east",
		self:create_taglist(s)
	}
	return self.widget
end

return T
