local user = {}

-- widgets variables --

user.notif_center = false
user.control = false
user.calendar = false
user.dnd = true
user.float_value = false
user.opacity_value = true
user.tray = false

-- actual colorsheme --

user.color = 'nymph'

-- openweather --

user.opweath_api = "your_api_key"
user.opweath_passwd = "your_password"
user.coordinates = { "53.9", "27.566667" }

-- user home and awm config --

user.home = os.getenv("HOME") .. "/"
user.awm_config = user.home .. ".config/awesome/"

-- bins --

user.bins = {
	lutgen = user.awm_config .. "other/bin/lutgen",
	greenclip = user.awm_config .. "/other/bin/greenclip",
	colorpicker = user.awm_config .. "other/bin/colorpicker",
	qr_codes = user.awm_config .. "other/bin/qr_codes"
}

return user
