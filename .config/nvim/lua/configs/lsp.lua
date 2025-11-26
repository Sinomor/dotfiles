local capabilities = require("configs.lspconfig").capabilities
local lsp = vim.lsp
local handlers = vim.g.re_nvim_border_style == "rounded"
		and {
			["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "rounded" }),
			["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, { border = "rounded" }),
		}
	or {}

local servers = {
	"lua_ls",
	"html",
	"cssls",
	"pyright",
	"bashls",
	"ts_ls",
	"vala_ls",
	"biome",
	"clangd",
	"qmlls",
}

for _, name in ipairs(servers) do
	lsp.config(name, {
		handlers = handlers,
		capabilities = capabilities,
	})
	lsp.enable(name)
end

lsp.config("pyright", {
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

lsp.config("bashls", {
	filetypes = { "sh", "bash", "zsh" },
})

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	}
	vim.buf.execute_command(params)
end

lsp.config("ts_ls", {
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

lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--header-insertion-decorators",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
		"--clang-tidy",
		"--clang-tidy-checks=*",
		"--compile-commands-dir=.",
		"--all-scopes-completion",
		"--cross-file-rename",
		"--pch-storage=memory",
	},
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
		clangdFileStatus = true,
	},
})

local cap = vim.lsp.protocol.make_client_capabilities()
cap.textDocument.completion.completionItem.snippetSupport = true
