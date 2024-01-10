local M = {}
                          
local conf = { noremap = true, silent = true }
local recur = { silent = true }
                          
local k = vim.api.nvim_set_keymap
                          
-- Keyboard shortcuts and mappings    
vim.o.tabstop = 2      -- Number of spaces for a TAB character      
vim.o.shiftwidth = 2   -- Number of spaces to use for autoindent    
vim.o.softtabstop = 2  -- Number of spaces for <Tab> and <BS> in insert mode
vim.wo.number = true   -- Show line numbers    


