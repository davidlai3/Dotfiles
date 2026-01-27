require("keymaps")
require("plugins")
require("plugin_config")


-- Relative line numbers
vim.cmd([[set relativenumber]])
-- Folding
vim.cmd([[setlocal foldmethod=indent]])
vim.cmd([[setlocal foldlevel=99]])
vim.cmd([[setlocal foldnestmax=1]])

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
