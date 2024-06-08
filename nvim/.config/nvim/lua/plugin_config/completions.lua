local luasnip = require("luasnip")
local cmp = require'cmp'

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
		require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
	end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = {
		['<CR>'] = cmp.mapping(function(fallback)
		if cmp.visible() then
			if luasnip.expandable() then
				luasnip.expand()
			else
				cmp.confirm({
					select = true,
				})
			end
		else
			fallback()
		end
		end),

		["<Tab>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_next_item()
		elseif luasnip.locally_jumpable(1) then
			luasnip.jump(1)
		else
			fallback()
		end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		elseif luasnip.locally_jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
		end, { "i", "s" }),
	},
	sources = {
		-- Copilot source
		{ name = "copilot", group_index = 2, max_item_count = 2 },
		-- Other
		{ name = "vimtex", group_index = 2 },
		{ name = "nvim_lsp", group_index = 2 },
		{ name = "luasnip", group_index = 2 },
	},
	sorting = {
		priority_weight = 2,
		comparators = {
			require("copilot_cmp.comparators").prioritize,

			-- Below is the default comparitor list and order for nvim-cmp
			cmp.config.compare.offset,
			-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'git' },
}, {
  { name = 'buffer' },
})
})
require("cmp_git").setup() ]]-- 

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')['clangd'].setup {
	capabilities = capabilities
}
require('lspconfig')['pyright'].setup {
	capabilities = capabilities
}
require('lspconfig')['lua_ls'].setup {
	capabilities = capabilities
}
require('lspconfig')['tsserver'].setup {
	capabilities = capabilities
}
require('lspconfig')['ocamllsp'].setup {
	capabilities = capabilities
}


