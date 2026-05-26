return {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        vim.o.termguicolors = true
        vim.o.background = 'light'
        require('gruvbox').setup({})
        vim.cmd.colorscheme 'gruvbox'
    end,
}
