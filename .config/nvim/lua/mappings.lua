local map = vim.keymap.set
local api = vim.api
vim.g.mapleader = " "

api.nvim_set_keymap("n", "<Up>", "<NOP>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<Down>", "<NOP>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<Left>", "<NOP>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<Right>", "<NOP>", { noremap = true, silent = true })

api.nvim_set_keymap("i", "<Up>", "<NOP>", { noremap = true, silent = true })
api.nvim_set_keymap("i", "<Down>", "<NOP>", { noremap = true, silent = true })
api.nvim_set_keymap("i", "<Left>", "<NOP>", { noremap = true, silent = true })
api.nvim_set_keymap("i", "<Right>", "<NOP>", { noremap = true, silent = true })

map("n", "<leader>q", "<cmd>q<CR>")
map("n", "<leader>Q", "<cmd>q!<CR>")
map("n", "<leader>w", "<cmd>w<CR>")

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
map("n", "<S-e>", "<cmd>NvimTreeFocus<CR>")

map("n", "<leader>m", function()
	local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
	require("menu").open(options, { border = true })
end, { desc = "context menu" })

map("n", "<RightMouse>", function()
	vim.cmd.exec('"normal! \\ <RightMouse>"')
	local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
	require("menu").open(options, { mouse = true, border = true })
end, { desc = "right click context menu" })

map("n", "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

map({ "n", "t" }, "<leader>t", function()
	require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm" })
end)
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

map("n", "<leader>b", "<cmd>enew<CR>")

map("n", "<S-l>", function()
	require("nvchad.tabufline").next()
end)
map("n", "<S-h>", function()
	require("nvchad.tabufline").prev()
end)
map("n", "<leader>d", function()
	require("nvchad.tabufline").close_buffer()
end)

map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "telescope find files" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
