local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "prettierd" },
		scss = { "prettierd" },
		html = { "prettierd" },
		json = { "prettierd" },
		jsonc = { "prettierd" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		python = { "black" },
		c = { "clang_format" },
		sh = { "beautysh" },
		cpp = { "clang_format" },
		markdown = { "prettierd" },
		markdown_inline = { "prettierd" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

return options
