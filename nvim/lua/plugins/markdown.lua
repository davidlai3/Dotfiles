return {
    -- Browser preview with KaTeX math. Nothing is drawn in the buffer.
    -- (render-markdown.nvim lived here once; in-buffer decoration hurt my eyes.)
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle' },
    ft = { 'markdown' },
    build = function()
        vim.fn['mkdp#util#install']()
    end,
    init = function()
        vim.g.mkdp_filetypes = { 'markdown' }
        vim.g.mkdp_auto_close = 0
        vim.g.mkdp_preview_options = { katex = {} }
        vim.g.mkdp_theme = 'light'
    end,
    keys = {
        { '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Markdown preview' },
    },
}
