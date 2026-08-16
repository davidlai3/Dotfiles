return {
    {
        "microscope.nvim",
        dir = "~/Coding/microscope.nvim",
        -- Registers <leader>ff (files field focused) and <leader>fg (grep field
        -- focused). Both open the same picker.
        config = function()
            require("microscope").setup({})
        end,
    },
}
