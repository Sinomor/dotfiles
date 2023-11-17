local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.lua_ls.setup {}

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = false,
})
