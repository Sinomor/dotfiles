dofile(vim.g.base46_cache .. "telescope")

return {
	defaults = {
		prompt_prefix = "   ",
		selection_caret = " ",
		entry_prefix = " ",
		sorting_strategy = "ascending",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.6,
			},
			width = 0.8,
			height = 0.8,
		},
		mappings = {
			n = { ["q"] = require("telescope.actions").close },
		},
	},

	extensions_list = { "themes", "terms" },
	extensions = {},
}
