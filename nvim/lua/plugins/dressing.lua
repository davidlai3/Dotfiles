return {
    -- Only here to override vim.ui.select / vim.ui.input, which telescope-ui-select
    -- used to do. Keeps <leader>ca code actions as a floating menu instead of the
    -- built-in command-line prompt.
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
        input = {
            border = "rounded",
        },
        select = {
            backend = { "builtin" },
            builtin = {
                border = "rounded",
                relative = "cursor",
            },
        },
    },
}
