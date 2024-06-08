-- Install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Plugins
require('lazy').setup({

	-- Core Packages
	'ellisonleao/gruvbox.nvim',
	'nvim-tree/nvim-tree.lua',
	'nvim-tree/nvim-web-devicons',
	'nvim-lualine/lualine.nvim',
	'nvim-treesitter/nvim-treesitter',
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim'
		}
	},

	-- Git 
	'NeogitOrg/neogit',

	-- LSP
	{
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
		'onsails/lspkind.nvim'
	},

	-- Completion
	'neovim/nvim-lspconfig',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/nvim-cmp',

	'L3MON4D3/LuaSnip',
	'saadparwaiz1/cmp_luasnip',
	'rafamadriz/friendly-snippets',

	{
	"zbirenbaum/copilot-cmp",
	config = function ()
		require("copilot_cmp").setup()
	end
	},

	-- Copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({})
		end,
	},

	-- LaTeX
	'lervag/vimtex',
	'micangl/cmp-vimtex',

	-- Autopairs
	'jiangmiao/auto-pairs',

	-- Surround Text
	'tpope/vim-surround',

	-- React
	'mlaursen/vim-react-snippets',

})

