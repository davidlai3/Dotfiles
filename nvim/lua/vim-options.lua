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

-- Recent files (telescope's oldfiles picker used to own this)
k("n", "<leader><leader>", ":browse oldfiles<CR>", { desc = "Recent files" })

-- Copy and paste using system
-- Over ssh there is no local clipboard to talk to, so route "+ through OSC 52
-- escape sequences instead: the text rides the existing terminal connection out
-- to whatever terminal is on the other end and lands in *its* clipboard. tmux
-- passes these through (set-clipboard on, see tmux/.tmux.conf).
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local osc52 = require("vim.ui.clipboard.osc52")

  -- Mirror of whatever was last sent out over OSC 52, so that "+p still works.
  -- Reading the real clipboard back would need the terminal to answer an OSC 52
  -- query, which terminals either prompt for or refuse outright. This cannot be
  -- served from the unnamed register: after "+y the unnamed register *is* the
  -- clipboard register, so asking for it re-enters this provider and nvim's
  -- recursion guard returns empty.
  local last = { { "" }, "v" }

  local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
      last = { lines, regtype }
      send(lines, regtype)
    end
  end

  local function paste()
    return last
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

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

-- Nice indentation for markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "md" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.breakindentopt = "list:-1"
  end,
})
