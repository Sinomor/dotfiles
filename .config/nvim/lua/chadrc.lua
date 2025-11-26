local M = {}

M.base46 = {
	theme = "adwaita",
	transparency = false,
}

M.ui = {
	statusline = {
		theme = "vscode_colored",
	},
	cmp = {
		style = "flat_dark",
	},
	tabufline = {
		order = { "treeOffset", "buffers", "tabs" },
	},
	telescope = { style = "borderless" },
}

M.lsp = { signature = true }

M.term = {
	winopts = { number = false, relativenumber = false },
	sizes = { sp = 0.4, ["bo sp"] = 0.4 },
	float = {
		relative = "win",
		row = 0.15,
		col = 0.15,
		width = 0.7,
		height = 0.6,
		border = "none",
	},
}

M.colorify = {
	mode = "bg",
}

return M
