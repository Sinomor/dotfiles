local M = {}

M.base_30 = {
	white = "#ffffff",
	darker_black = "#1D1D20",
	black = "#28282C",
	black2 = "#36363A",
	one_bg = "#36363A",
	one_bg2 = "#48484B",
	one_bg3 = "#48484B",
	grey = "#5A5A5E",
	grey_fg = "#666666",
	grey_fg2 = "#666666",
	light_grey = "#666666",
	red = "#ed333b",
	baby_pink = "#f66151",
	pink = "#f5756b",
	line = "#403f3f",
	green = "#57e389",
	vibrant_green = "#8ff0a4",
	blue = "#51a1ff",
	nord_blue = "#4fd2fd",
	yellow = "#f8e45c",
	sun = "#fbeb79",
	purple = "#c061cb",
	dark_purple = "#9141ac",
	teal = "#99c1f1",
	orange = "#ffa348",
	cyan = "#4fd2fd",
	statusline_bg = "#303030",
	lightbg = "#303030",
	pmenu_bg = "#51a1ff",
	folder_bg = "#51a1ff",
}

M.base_16 = {
	base00 = "#1D1D20",
	base01 = "#28282C",
	base02 = "#36363A",
	base03 = "#48484B",
	base04 = "#ffffff",
	base05 = "#ffffff",
	base06 = "#ffffff",
	base07 = "#ffffff",
	base08 = "#ed333b",
	base09 = "#ffa348",
	base0A = "#f8e45c",
	base0B = "#57e389",
	base0C = "#4fd2fd",
	base0D = "#51a1ff",
	base0E = "#c061cb",
	base0F = "#ffffff",
}

M.type = "dark"

M = require("base46").override_theme(M, "adwaita")

return M
