local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable",
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- treesitter
	{ 'nvim-treesitter/nvim-treesitter' },
	-- lsp
	{ 'neovim/nvim-lspconfig' },
	-- cmp
	{ 'hrsh7th/cmp-nvim-lsp' }, { 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' }, { 'hrsh7th/cmp-cmdline' },
	{ 'hrsh7th/nvim-cmp' }, { 'hrsh7th/cmp-vsnip' },
	{ 'hrsh7th/vim-vsnip' },
	-- mason
	{ 'williamboman/mason.nvim' },
	-- tree
	{ 'nvim-tree/nvim-tree.lua' },
	-- buffer
	{
		"willothy/nvim-cokeline",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true
	},
	-- statusline
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'linrongbin16/lsp-progress.nvim' }
	},
	-- git signs
	{ 'lewis6991/gitsigns.nvim' },
	-- autopairs
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {}
	},
	-- colorschemes
	{ dir = '~/.config/nvim/colors/nymph' },
	{ dir = '~/.config/nvim/colors/satyr' },
	{ dir = '~/.config/nvim/colors/biscuit' },
	{ dir = '~/.config/nvim/colors/mountain' },
	{ dir = '~/.config/nvim/colors/gruvbox' },
	{ dir = '~/.config/nvim/colors/gruvbox_light' },
	{ dir = '~/.config/nvim/colors/everforest' },
	{ dir = '~/.config/nvim/colors/catppuccin' },
	{ dir = '~/.config/nvim/colors/catppuccin_latte' },
	{ dir = '~/.config/nvim/colors/rosepine_dawn' },
	{ dir = '~/.config/nvim/colors/stardew' },
	{
		"NvChad/nvim-colorizer.lua",
		config = function(_, opts)
			require("colorizer").setup(opts)
			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
				end, 0)
		end,
	},
})
