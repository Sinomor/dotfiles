local p = require('gruvbox_light.palette')
local M = {}

function M.set_colors()

	local theme = {
		-- base highlights
		Normal = { fg = p.fg, bg = p.bg },
		NormalNC = { fg = p.fg, bg = p.bg },
		SignColumn = { fg = p.bg, bg = p.bg },
		FoldColumn = { fg = p.fg_alt, bg = p.bg },
		VertSplit = { fg = p.bg_urgent, bg = p.bg },
		Folded = { fg = p.fg, bg = p.bg },
		EndOfBuffer = { fg = p.bg },
		ColorColumn = { bg = p.bg_alt },
		Conceal = { fg = p.fg_alt },
		QuickFixLine = { bg = p.bg },
		Terminal = { fg= p.fg, bg = p.fg },

		IncSearch = { fg = p.bg, bg = p.accent },
		Search = { fg = p.bg, bg = p.accent },
		Visual = { fg = p.bg, bg = p.accent },
		VisualNOS = { bg = p.bg },

		Cursor = { fg = p.fg, bg = p.fg },
		CursorColumn = { bg = p.bg_alt },
		CursorIM = { fg = p.fg, bg = p.fg },
		CursorLine = { bg = p.bg_alt },
		CursorLineNr = { fg = p.accent },
		lCursor = { fg = p.fg, bg = p.fg },
		LineNr = { fg = p.fg_alt, bg = p.bg },
		TermCursor = { fg = p.fg, bg = p.fg },
		TermCursorNC = { fg = p.fg, bg = p.fg },

		DiffAdd = { fg = p.green, bg = p.bg },
		DiffChange = { fg = p.yellow, bg = p.bg },
		DiffDelete = { fg = p.red, bg = p.bg },
		DiffText = { fg = p.fg, bg = p.bg },

		Directory = { fg = p.blue },
		ErrorMsg = { fg = p.red },
		WarningMsg = { fg = p.yellow },
		ModeMsg = { fg = p.fg },
		MoreMsg = { fg = p.fg },
		MsgArea = { fg = p.fg, bg = p.bg },
		MsgSeparator = { fg = p.bg_urgent, bg = p.bg },
		Question = { fg = p.accent },

		MatchParen = { fg = p.yellow },
		NonText = { fg = p.fg_alt },
		SpecialKey = { fg = p.fg_alt },
		Whitespace = { fg = p.bg_alt },

		Pmenu = { fg = p.fg, bg = p.bg_alt },
		PmenuSbar = { bg = p.bg_urgent },
		PmenuSel = { fg = p.bg, bg = p.accent },
		PmenuThumb = { bg = p.accent },
		WildMenu = { fg = p.fg, bg = p.bg_alt },
		NormalFloat = { fg = p.fg, bg = p.bg_alt },

		TabLine = { fg = p.fg, bg = p.bg },
		TabLineFill = { fg = p.fg, bg = p.bg },
		TabLineSel = { fg = p.accent, bg = p.bg },
		StatusLine = { fg = p.fg, bg = p.bg },
		StatusLineNC = { bg = p.bg, fg = p.bg },

		SpellBad = { fg = p.red },
		SpellCap = { fg = p.blue },
		SpellLocal = { fg = p.accent },
		SpellRare = { fg = p.magenta },

		-- syntax
		Boolean = { fg = p.orange },
		Character = { fg = p.orange },
		Conditional = { fg = p.magenta },
		Constant = { fg = p.blue },
		Debug = { fg = p.blue },
		Define = { fg = p.red },
		Error = { fg = p.red },
		Exception = { fg = p.magenta },
		Float = { fg = p.yellow },
		FloatBorder = { fg = p.fg_alt },
		Function = { fg = p.blue },
		Include = { fg = p.red },
		Keyword = { fg = p.red },
		Label = { fg = p.blue },
		Macro = { fg = p.blue },
		Number = { fg = p.yellow },
		Operator = { fg = p.red },
		PreCondit = { fg = p.blue },
		PreProc = { fg = p.blue },
		Repeat = { fg = p.magenta },
		Special = { fg = p.blue },
		SpecialChar = { fg = p.orange },
		Statement = { fg = p.blue },
		Storage = { fg = p.blue },
		StorageClass = { fg = p.blue },
		String = { fg = p.green },
		Structure = { fg = p.blue },
		Substitute = { fg = p.accent },
		Tag = { fg = p.red },
		Title = { fg = p.magenta },
		Type = { fg = p.blue },
		Typedef = { fg = p.blue },
		Variable = { fg = p.blue },

		Comment = { fg = p.fg_alt },
		SpecialComment = { fg = p.fg_alt },
		Todo = { fg = p.fg_alt },
		Delimiter = { fg = p.fg },
		Identifier = { fg = p.fg },
		Ignore = { fg = p.fg },
		Underlined = { underline = true },

		-- bufferline.nvim: https://github.com/akinsho/bufferline.nvim
		BufferLineFill = { fg = p.bg, bg = p.bg },
		BufferLineIndicatorSelected = { fg = p.accent },

		-- Diagnostic
		DiagnosticError = { fg = p.red },
		DiagnosticHint = { fg = p.accent },
		DiagnosticInfo = { fg = p.blue },
		DiagnosticWarn = { fg = p.yellow },

		-- diff
		diffAdded = { fg = p.blue },
		diffChanged = { fg = p.yellow },
		diffFile = { fg = p.fg },
		diffIndexLine = { fg = p.fg },
		diffLine = { fg = p.fg },
		diffNewFile = { fg = p.magenta },
		diffOldFile = { fg = p.orange },
		diffRemoved = { fg = p.red },

		-- gitsigns: https://github.com/lewis6991/gitsigns.nvim
		GitSignsAdd = { fg = p.green },
		GitSignsChange = { fg = p.yellow },
		GitSignsDelete = { fg = p.red },

		-- indent-blankline.nvim: https://github.com/lukas-reineke/indent-blankline.nvim
		IndentBlanklineChar = { fg = p.bg_alt },

		-- nvim-tree.lua: https://github.com/nvim-tree/nvim-tree.lua
		NvimTreeEmptyFolderName = { fg = p.fg_alt },
		NvimTreeEndOfBuffer = { fg = p.fg, bg = p.bg },
		NvimTreeEndOfBufferNC = { fg = p.fg, bg = p.bg },
		NvimTreeFolderIcon = { fg = p.fg, bg = p.bg },
		NvimTreeFolderName = { fg = p.fg },
		NvimTreeGitDeleted = { fg = p.red },
		NvimTreeGitDirty = { fg = p.red },
		NvimTreeGitNew = { fg = p.blue },
		NvimTreeImageFile = { fg = p.fg_alt },
		NvimTreeIndentMarker = { fg = p.accent },
		NvimTreeNormal = { fg = p.fg, bg = p.bg },
		NvimTreeNormalNC = { fg = p.fg, bg = p.bg },
		NvimTreeOpenedFolderName = { fg = p.accent },
		NvimTreeRootFolder = { fg = p.fg_alt },
		NvimTreeSpecialFile = { fg = p.red },
		NvimTreeStatusLineNC = { bg = p.bg, fg = p.bg },
		NvimTreeSymlink = { fg = p.blue },
		NvimTreeVertSplit = { fg = p.bg, bg = p.bg },

		-- nvim-treesitter: https://github.com/nvim-treesitter/nvim-treesitter
		["@attribute"] = { fg = p.blue },
		["@boolean"] = { fg = p.orange },
		["@character"] = { fg = p.orange },
		["@comment"] = { fg = p.fg_alt },
		["@conditional"] = { fg = p.magenta },
		["@constant"] = { fg = p.accent },
		["@constant.builtin"] = { fg = p.accent },
		["@constant.macro"] = { fg = p.accent },
		["@constructor"] = { fg = p.blue },
		["@exception"] = { fg = p.magenta },
		["@field"] = { fg = p.accent },
		["@float"] = { fg = p.yellow },
		["@function"] = { fg = p.blue },
		["@function.builtin"] = { fg = p.blue },
		["@function.macro"] = { fg = p.blue },
		["@include"] = { fg = p.red },
		["@keyword"] = { fg = p.red },
		["@keyword.function"] = { fg = p.red },
		["@keyword.operator"] = { fg = p.red },
		["@keyword.return"] = { fg = p.red },
		["@label"] = { fg = p.accent },
		["@method"] = { fg = p.blue },
		["@namespace"] = { fg = p.accent },
		["@number"] = { fg = p.yellow },
		["@operator"] = { fg = p.red },
		["@parameter"] = { fg = p.yellow },
		["@parameter.reference"] = { fg = p.yellow },
		["@property"] = { fg = p.accent },
		["@punctuation.bracket"] = { fg = p.fg },
		["@punctuation.delimiter"] = { fg = p.fg },
		["@punctuation.special"] = { fg = p.fg },
		["@repeat"] = { fg = p.magenta },
		["@string"] = { fg = p.green },
		["@string.escape"] = { fg = p.orange },
		["@string.regex"] = { fg = p.orange },
		["@string.special"] = { fg = p.orange },
		["@symbol"] = { fg = p.red },
		["@tag"] = { fg = p.red },
		["@tag.attribute"] = { fg = p.yellow },
		["@tag.delimiter"] = { fg = p.blue },
		["@type"] = { fg = p.blue },
		["@type.builtin"] = { fg = p.blue },
		["@variable"] = { fg = p.fg },
		["@variable.builtin"] = { fg = p.fg },
		["@text"] = { fg = p.fg },
		--["@text.danger"]
		--["@text.emphasis"]
		--["@text.environment.name"]
		--["@text.environtment"]
		--["@text.literal"]
		--["@text.math"]
		--["@text.note"]
		--["@text.reference"]
		--["@text.strike"]
		--["@text.strong"]
		--["@text.title"]
		--["@text.underline"]
		--["@text.uri"]
		--["@text.warning"]

		-- LSP semantic tokens
		["@lsp.type.comment"] = { link = "@comment" },
		["@lsp.type.enum"] = { link = "@type" },
		["@lsp.type.interface"] = { link = "Identifier" },
		["@lsp.type.keyword"] = { link = "@keyword" },
		["@lsp.type.namespace"] = { link = "@namespace" },
		["@lsp.type.parameter"] = { link = "@parameter" },
		["@lsp.type.property"] = { link = "@property" },
		["@lsp.type.variable"] = {}, -- use treesitter styles for regular variables
		["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
		["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
		["@lsp.typemod.operator.injected"] = { link = "@operator" },
		["@lsp.typemod.string.injected"] = { link = "@string" },
		["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
		["@lsp.typemod.variable.injected"] = { link = "@variable" },

		-- telescope.nvim: https://github.com/nvim-telescope/telescope.nvim
		TelescopeBorder = { fg = p.fg_alt, bg = p.bg },
		TelescopeNormal = { fg = p.fg, bg = p.bg },
		TelescopeSelection = { fg = p.bg, bg = p.accent },
	}

	vim.g.terminal_color_0 = p.bg
	vim.g.terminal_color_1 = p.red
	vim.g.terminal_color_2 = p.green
	vim.g.terminal_color_3 = p.yellow
	vim.g.terminal_color_4 = p.blue
	vim.g.terminal_color_5 = p.magenta
	vim.g.terminal_color_6 = p.cyan
	vim.g.terminal_color_7 = p.fg
	vim.g.terminal_color_8 = p.fg_alt
	vim.g.terminal_color_9 = p.red
	vim.g.terminal_color_10 = p.green
	vim.g.terminal_color_11 = p.yellow
	vim.g.terminal_color_12 = p.blue
	vim.g.terminal_color_13 = p.magenta
	vim.g.terminal_color_14 = p.cyan
	vim.g.terminal_color_15 = p.fg

	return theme
end

return M
