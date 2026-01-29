-- Relative line numbers
vim.cmd([[set relativenumber]])
-- Folding
vim.cmd([[setlocal foldmethod=indent]])
vim.cmd([[setlocal foldlevel=99]])
vim.cmd([[setlocal foldnestmax=1]])
-- Tabs
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
-- Keymaps
local M = {}
                          
local conf = { noremap = true, silent = true }
local recur = { silent = true }
                          
local k = vim.api.nvim_set_keymap

-- Keyboard shortcuts and mappings    
vim.o.tabstop = 4      -- Number of spaces for a TAB character      
vim.o.shiftwidth = 4 -- Number of spaces to use for autoindent    
vim.o.softtabstop = 4  -- Number of spaces for <Tab> and <BS> in insert mode
vim.wo.number = true   -- Show line numbers    

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- jk > ESC
k("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Copy and paste using system
-- k("", "<C-p>", "<C-r>+", {desc = "Use Control P to paste from system"})
k("", "Y", "\"+y", {desc = "Use uppercase Y for system clip(motions work)"})

-- Keeps text selected when shifting 
k("v", ">", ">gv", {desc = "Selects again"})
k("v", "<", "<gv", {desc = "Selects again"})
k("x", ">", ">gv", {desc = "Selects again"})
k("x", "<", "<gv", {desc = "Selects again"})

-- Moves lines up and down
k("v", "J", ":m '>+1<CR>gv=gv", {desc = "Stays in place during join"})
k("v", "K", ":m '<-2<CR>gv=gv", {desc = "Stays in place during join"})
k("x", "J", ":m '>+1<CR>gv=gv", {desc = "Stays in place during join"})
k("x", "K", ":m '<-2<CR>gv=gv", {desc = "Stays in place during join"})

--[[
-- Page up and down
k("n", "J", "<C-f>M", { noremap = true, silent = true })
k("n", "K", "<C-b>M", { noremap = true, silent = true })

-- Join lines
k("n", "H", "J", { noremap = true, silent = true })
]]
