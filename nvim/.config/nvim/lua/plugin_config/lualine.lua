require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'solarized',
		-- theme = 'gruvbox',
	},
	sections = {
		lualine_a = {
			{
				'mode', -- can change to filename 
				path = 1,
			}
		}
	}
}
