local util = require('satyr.util')

local M = {}

function M.colorscheme()
	if vim.g.colors_name then
		vim.cmd('hi clear')
	end

	vim.opt.termguicolors = true
	vim.g.colors_name = 'satyr'

	local theme = require('satyr.theme').set_colors()
	-- Set theme highlights
	for group, color in pairs(theme) do
		util.highlight(group, color)
	end
end

return M
