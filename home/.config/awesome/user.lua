local gears = require("gears")
local beautiful = require("beautiful")

local user = {}

user.font_name = 'JetbrainsMono Nerd Font'
user.font_size = 11
user.useless_gap = 5
user.border_width = 2
user.bar_size = 56

-- system --

user.battery = false
user.bat_device = "BAT1"

-- username --

user.name = os.getenv("USER")

-- widgets vars --

user.titlebar_pos = 'Top'
user.launcher_fullscreen = false
user.control_fullscreen = false
user.bar_pos = 'Bottom'
user.notifs_pos = 'Top Center'
user.bar_float = false

-- compositor opacity --

user.opacity_value = false

-- actual colorsheme --

user.color = 'nymph'

-- openweather --

user.opweath_api = "e434b5435a979de6e155570590bee89b"
user.coordinates = { lat = 53.9, lon = 27.566667 }

-- user home and awm config --

user.home = os.getenv("HOME") .. "/"
user.awm_config = user.home .. ".config/awesome/"

-- walls --

user.wall_type = 'Random'
user.wall_update = 1800
user.wall_path = '/home/sinomor/frieren.jpg'
user.wall_color = '#fbf1c7'
user.wall_tile_size = 30
user.wall_tile_type = 'Diagonal Line'
user.wall_tile_icon = '󰘧'

-- applications --

user.terminal = 'alacritty'
user.browser = "librewolf"
user.file_manager = "thunar"

-- bins --

user.bins = {
	lutgen = user.awm_config .. "other/bin/lutgen",
	greenclip = user.awm_config .. "/other/bin/greenclip",
	colorpicker = user.awm_config .. "other/bin/colorpicker",
	qr_codes = user.awm_config .. "other/bin/qr_codes"
}

user.books_path = "~/.disk/Books/'10 класс'/"

user.autostart = {
	[[ bash -c "pgrep -x polkit-gnome-au > /dev/null || /usr/libexec/polkit-gnome-authentication-agent-1" ]],
	[[ bash -c "pgrep -x greenclip > /dev/null || $HOME/.config/awesome/other/bin/greenclip daemon" ]],
	[[ bash -c "pkill xsettingsd \
		while pgrep -u $UID -x xsettingsd >/dev/null; do sleep 1; done \
		xsettingsd" 
	]]
}

return user
