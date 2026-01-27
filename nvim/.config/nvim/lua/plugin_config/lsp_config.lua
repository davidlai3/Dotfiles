require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {"lua_ls", "pyright", "tsserver", "rust_analyzer", "clangd", "html", "ocamllsp", "texlab"},
})


local on_attach = function(_, _)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
	vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {})
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lspconfig").lua_ls.setup {
	on_attach = on_attach,
	capabilities = capabilities
}

require("lspconfig").pyright.setup {
	on_attach = on_attach,
	capabilities = capabilities
}

require("lspconfig").tsserver.setup {
	on_attach = on_attach,
	capabilities = capabilities
}

require("lspconfig").rust_analyzer.setup {
	on_attach = on_attach,
	capabilities = capabilities
}

require("lspconfig").clangd.setup {
	on_attach = on_attach,
	capabilities = capabilities;
}

require("lspconfig").ocamllsp.setup {
	on_attach = on_attach,
	capabilities = capabilities
}

require("lspconfig").html.setup {
	cmd = { "html-languageserver", "--stdio" },
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true
		}
	},
	settings = {},
	on_attach = on_attach,
	capabilities = capabilities
}
