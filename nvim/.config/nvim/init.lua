require("keymaps")
require("plugins")
require("plugin_config")


-- Relative line numbers
vim.cmd([[set relativenumber]])
-- Folding
vim.cmd([[setlocal foldmethod=indent]])
vim.cmd([[setlocal foldlevel=99]])
vim.cmd([[setlocal foldnestmax=1]])
