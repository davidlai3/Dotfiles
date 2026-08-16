return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
        {
            "<leader>gd",
            "<cmd>DiffviewOpen<cr>",
            desc = "Diff unstaged changes (Diffview)",
        },
        {
            "<leader>gc",
            "<cmd>DiffviewOpen HEAD^!<cr>",
            desc = "Diff last commit (Diffview)",
        },
        {
            "<leader>gq",
            "<cmd>DiffviewClose<cr>",
            desc = "Close Diffview",
        },
    },
    opts = {
        enhanced_diff_hl = true,
        view = {
            default = { layout = "diff2_horizontal" },
            merge_tool = { layout = "diff3_horizontal" },
        },
        keymaps = {
            view = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
            file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
        },
    },
}
