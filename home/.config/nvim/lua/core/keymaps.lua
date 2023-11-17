vim.g.mapleader = " "

-- tree
vim.keymap.set("n", "<leader>tt", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>tf", ":NvimTreeFocus<CR>")

-- buffer
vim.keymap.set("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", { silent = true })
vim.keymap.set("n", "<Tab>", "<Plug>(cokeline-focus-next)", { silent = true })
vim.keymap.set("n", "<leader>bd", ":bp<bar>sp<bar>bn<bar>bd<CR>")

-- other
vim.keymap.set("n", "<leader>Q", ":qall<CR>")
vim.keymap.set("n", "<leader>u", ":u<CR>")
vim.keymap.set("n", "<leader>r", ":redo<CR>")
vim.keymap.set("n", "<C-q>", ":q!<CR>")
vim.keymap.set("n", "<C-s>", ":w<CR>")

-- LSP
vim.keymap.set('n', '<leader>lf', vim.diagnostic.open_float)
vim.keymap.set('n', '[l', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']l', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>ll', vim.diagnostic.setloclist)
