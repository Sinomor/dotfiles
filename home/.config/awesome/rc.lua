pcall(require, "luarocks.loader")
local beautiful = require("beautiful")

beautiful.init("~/.config/awesome/theme/theme.lua")

require("config")
require("ui")
require("user")
require("scripts")
