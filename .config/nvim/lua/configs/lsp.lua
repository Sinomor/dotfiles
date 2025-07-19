local on_attach = require("configs.lspconfig").on_attach
local on_init = require("configs.lspconfig").on_init
local capabilities = require("configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

local servers = {
	"lua_ls",
	"html",
	"cssls",
	"pyright",
	"bashls",
	"ts_ls",
	"vala_ls",
	"biome",
	"qmlls",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		on_init = on_init,
		capabilities = capabilities,
	})
end

lspconfig.pyright.setup({
	settings = {
		pyright = {
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				ignore = { "*" },
			},
		},
	},
})

lspconfig.bashls.setup({
	filetypes = { "sh", "bash", "zsh" },
})

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	}
	vim.buf.execute_command(params)
end

lspconfig.ts_ls.setup({
	init_options = {
		preferences = {
			disableSuggestions = true,
		},
	},
	commands = {
		OrganizeImports = {
			organize_imports,
			description = "Organize Imports",
		},
	},
})

local cap = vim.lsp.protocol.make_client_capabilities()
cap.textDocument.completion.completionItem.snippetSupport = true
