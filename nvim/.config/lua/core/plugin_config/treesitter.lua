require 'nvim-treesitter.configs'.setup {
	ensure_installed = {"c", "cpp", "python", "lua", "astro"},

	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
	},
}
