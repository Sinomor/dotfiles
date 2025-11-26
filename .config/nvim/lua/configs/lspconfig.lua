local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP " .. desc }
	end

	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Show signature help"))

	map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
	map("n", "<leader>ra", require("nvchad.lsp.renamer"), opts("NvRenamer"))
end

-- disable semanticTokens
M.on_init = function(client, _)
	if client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

M.defaults = function()
	dofile(vim.g.base46_cache .. "lsp")
	require("nvchad.lsp").diagnostic_config()

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			M.on_attach(_, args.buf)
		end,
	})

	local lua_lsp_settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				library = {
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
					vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
					"${3rd}/luv/library",
				},
			},
		},
	}

	vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
	vim.lsp.config("lua_ls", { settings = lua_lsp_settings })
	vim.lsp.enable("lua_ls")
end

return M
