local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
   end
    return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerInstall
augroup end
]])

local packer = require("packer")
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

return require('packer').startup(function(use)
    -- Core Package
    use 'wbthomason/packer.nvim'
		use 'ellisonleao/gruvbox.nvim'
		use 'nvim-tree/nvim-tree.lua'
		use 'nvim-tree/nvim-web-devicons'
		use 'nvim-lualine/lualine.nvim'
		use 'nvim-treesitter/nvim-treesitter'
		use {
			'nvim-telescope/telescope.nvim',
			requires = {{'nvim-lua/plenary.nvim'}}
		}

		-- LSP
		use {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'neovim/nvim-lspconfig',
			'onsails/lspkind.nvim'
		}

		-- Completion
		use 'hrsh7th/nvim-cmp'
		use 'hrsh7th/cmp-nvim-lsp'
		use 'L3MON4D3/LuaSnip'
		use 'saadparwaiz1/cmp_luasnip'
		use 'rafamadriz/friendly-snippets'

		-- LaTeX
		use 'lervag/vimtex'
		use 'micangl/cmp-vimtex'

		-- Copilot
		use "zbirenbaum/copilot.lua"

		-- Copilot Completion
		use {
			"zbirenbaum/copilot-cmp",
			after = {"copilot.lua", "cmp-nvim-lsp", "nvim-cmp"},
			config = function ()
				require("copilot_cmp").setup()
			end
		}

		-- Autopairs
		use 'jiangmiao/auto-pairs'

		-- Surround Text
		use({
			"kylechui/nvim-surround",
			tag = "*", -- Use for stability; omit to use `main` branch for the latest features
			config = function()
					require("nvim-surround").setup({
							-- Configuration here, or leave empty to use defaults
					})
			end
		})


    if packer_bootstrap then
        require('packer').sync()
    end
end)


