-- Copilot CMP Stuff
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

local cmp = require("cmp")
local luasnip = require("luasnip")
vim.cmd [[packadd copilot-cmp]]

cmp.setup({
  mapping = {
		-- Tab to move to next item
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
				cmp.select_next_item()
      -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
      -- that way you will only jump inside the snippet region
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

		-- Shift + Tab to move to previous item
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
				cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

		['<CR>'] = cmp.mapping.confirm({ select = false }),
		['<C-o>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
	},
	snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

	completion = {
		completeopt = 'menu,menuone,noinsert,noselect'
	},

	sources = {
		-- Copilot Source
		{ name = 'copilot', group_index = 2, max_item_count = 2},
		-- Other sources
		{ name = 'vimtex', group_index = 2 },
    { name = 'nvim_lsp', group_index = 2, max_item_count = 5},
    { name = 'luasnip', group_index = 2 },
  },

	sorting = {
		priority_weight = 2,
		comparators = {
			require ("copilot_cmp.comparators").prioritize,
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

