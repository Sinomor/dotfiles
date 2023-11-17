-- Config --
vim.wo.number = true
vim.wo.relativenumber = true
vim.g.did_load_filetypes = 1
vim.g.formatoptions = "qrn1"
vim.opt.showmode = false
vim.opt.updatetime = 100
vim.wo.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.wo.linebreak = true
vim.opt.virtualedit = "block"
vim.opt.undofile = true
vim.opt.shell = "/bin/sh"
-- Mouse
vim.opt.mouse = "a"
vim.opt.mousefocus = true
-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
-- Clipboard
vim.opt.clipboard = "unnamedplus"
-- Shorter messages
vim.opt.shortmess:append("c")
-- Indent Settings
vim.opt.shiftwidth = 3
vim.opt.smartindent = true
vim.opt.tabstop = 3
vim.opt.softtabstop = 0
-- Fillchars
vim.opt.fillchars = {
	vert = "|",
	vertleft = "|",
	vertright = "|",
	verthoriz = "+",
	horiz = "-",
	horizup = "-",
	horizdown = "-",
	fold = "-",
	eob = " ",
	diff = "-",
	msgsep = "-",
	foldopen = "+",
	foldsep = "-",
	foldclose = ">"
}
-- Listchars
vim.opt.list = true
vim.opt.listchars = {
	space = '⋅',
	tab = '| ',
}
-- Colors --
vim.opt.termguicolors = true
vim.cmd.colorscheme{'nymph'}
