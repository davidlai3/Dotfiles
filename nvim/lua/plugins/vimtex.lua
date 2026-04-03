return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        vim.g.vimtex_view_method = "zathura"

        vim.g.vimtex_compiler_latexmk = {
            executable = "latexmk",
            options = {
                "-pdf",
                "-shell-escape",
                "-interaction=nonstopmode",
                "-synctex=1",
                "-file-line-error",
            },
        }
    end,
}

