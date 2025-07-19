local M = {}

M.base_30 = {
	white = "#ffffff",
	darker_black = "#161616",
	black = "#262626",
	black2 = "#262626",
	one_bg = "#393939",
	one_bg2 = "#525252",
	one_bg3 = "#525252",
	grey = "#6f6f6f",
	grey_fg = "#666666",
	grey_fg2 = "#666666",
	light_grey = "#666666",
	red = "#fa4d56",
	baby_pink = "#ff8389",
	pink = "#ee5396",
	line = "#393939",
	green = "#24a148",
	vibrant_green = "#42be65",
	blue = "#4589ff",
	nord_blue = "#78a9ff",
	yellow = "#f5c211",
	sun = "#f8e45c",
	purple = "#a56eff",
	dark_purple = "#be95ff",
	teal = "#99c1f1",
	orange = "#ffa348",
	cyan = "#4fd2fd",
	statusline_bg = "#262626",
	lightbg = "#262626",
	pmenu_bg = "#51a1ff",
	folder_bg = "#51a1ff",
}

M.base_16 = {
	base00 = "#161616",
	base01 = "#262626",
	base02 = "#393939",
	base03 = "#525252",
	base04 = "#ffffff",
	base05 = "#ffffff",
	base06 = "#ffffff",
	base07 = "#ffffff",
	base08 = "#fa4d56",
	base09 = "#ffa348",
	base0A = "#f5c211",
	base0B = "#24a148",
	base0C = "#1192e8",
	base0D = "#4589ff",
	base0E = "#a56eff",
	base0F = "#ffffff",
}

M.type = "dark"

M = require("base46").override_theme(M, "ibm")

return M
