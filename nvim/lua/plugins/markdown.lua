return {
    --[[
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        heading = {
            -- remove the section-number icons next to headers
            icons = {},
            -- no full-width background highlight behind headers
            width = 'block',
            backgrounds = {},
        },
        bullet = {
            -- keep the literal "-"/"*" instead of the oversized bullet glyphs
            enabled = false,
        },
    },
    ]]
}

-- GETTING RID OF THIS IT HURTS MY EYES
