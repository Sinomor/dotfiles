local awful = require("awful")

awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating
}

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])
end)

awful.mouse.snap.edge_enabled = false
