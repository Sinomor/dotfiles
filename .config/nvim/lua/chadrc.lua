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
		style = "atom_colored",
	},
	tabufline = {
		order = { "treeOffset", "buffers", "tabs" },
	},
	telescope = { style = "bordered" },
}

M.lsp = { signature = true }

M.term = {
	winopts = { number = false, relativenumber = false },
	sizes = { sp = 0.4, ["bo sp"] = 0.4 },
}

M.colorify = {
	mode = "bg",
}

return M
