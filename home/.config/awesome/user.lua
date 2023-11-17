local user = {}

-- widgets variables --

user.notif_center = false
user.profile = false
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

-- user home --

user.home = os.getenv("HOME") .. "/"

return user
