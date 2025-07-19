local M = {}

M.base_30 = {
	white = "#F4E6D2",
	darker_black = "#181515",
	black = "#221E1E",
	black2 = "#423939",
	one_bg = "#423939",
	one_bg2 = "#423939",
	one_bg3 = "#423939",
	grey = "#6D5F5F",
	grey_fg = "#6D5F5F",
	grey_fg2 = "#6D5F5F",
	light_grey = "#978787",
	red = "#CA3F3F",
	baby_pink = "#CA3F3F",
	pink = "#CA3F3F",
	line = "#423939",
	green = "#989F56",
	vibrant_green = "#989F56",
	blue = "#4A5A8D",
	nord_blue = "#517894",
	yellow = "#E39C45",
	sun = "#E39C45",
	purple = "#9F569A",
	dark_purple = "#9F569A",
	teal = "#629386",
	orange = "#E46A3A",
	cyan = "#517894",
	statusline_bg = "#423939",
	lightbg = "#423939",
	pmenu_bg = "#4A5A8D",
	folder_bg = "#4A5A8D",
}

M.base_16 = {
	base00 = "#181515",
	base01 = "#221E1E",
	base02 = "#423939",
	base03 = "#6D5F5F",
	base04 = "#F4E6D2",
	base05 = "#F4E6D2",
	base06 = "#F4E6D2",
	base07 = "#F4E6D2",
	base08 = "#CA3F3F",
	base09 = "#E46A3A",
	base0A = "#E39C45",
	base0B = "#989F56",
	base0C = "#517894",
	base0D = "#4A5A8D",
	base0E = "#9F569A",
	base0F = "#F4E6D2",
}

M.type = "dark"

M = require("base46").override_theme(M, "biscuit")

return M
