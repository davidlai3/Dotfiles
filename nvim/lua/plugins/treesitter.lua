return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install({
                "c", "cpp", "python", "bash", "lua", "json", "yaml", "toml",
                "markdown", "markdown_inline", "html", "css", "javascript",
                "typescript", "rust", "ocaml", "latex", "vim", "vimdoc", "query",
            })
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(ev)
                    pcall(vim.treesitter.start, ev.buf)
                end,
            })
        end,
    },
}
