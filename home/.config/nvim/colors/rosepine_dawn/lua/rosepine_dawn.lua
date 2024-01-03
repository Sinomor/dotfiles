local util = require('rosepine_dawn.util')

local M = {}

function M.colorscheme()
	if vim.g.colors_name then
		vim.cmd('hi clear')
	end

	vim.opt.termguicolors = true
	vim.g.colors_name = 'rosepine_dawn'

	local theme = require('rosepine_dawn.theme').set_colors()
	-- Set theme highlights
	for group, color in pairs(theme) do
		util.highlight(group, color)
	end
end

return M
