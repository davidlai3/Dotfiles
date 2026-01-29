return {
    { "hrsh7th/cmp-nvim-lsp"
},
{
    "L3MON4D3/LuaSnip",
    dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
    },
},
{
    "hrsh7th/nvim-cmp",
    config = function()
        local luasnip = require("luasnip")
        local cmp = require("cmp")
        local lspkind = require('lspkind')

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered({
                    border = "rounded", -- or "single", "double", "shadow"
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
                }),
                documentation = cmp.config.window.bordered({
                    border = "rounded",
                    winhighlight = "Normal:NormalFloat,FloatBorder:NormalFloat,Search:None",
                }),
            },
            formatting = {
                format = lspkind.cmp_format({
                    mode = "text",
                    menu = ({
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[LuaSnip]",
                        nvim_lua = "[Lua]",
                        latex_symbols = "[Latex]",
                    })
                }),
                --[[
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                    local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    kind.kind = " " .. (strings[1] or "") .. " "
                    kind.menu = "    (" .. (strings[2] or "") .. ")"

                    return kind
                end,
                ]]
            },
            mapping = {

                ['<CR>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if luasnip.expandable() then
                            luasnip.expand()
                        else
                            cmp.confirm({
                                select = true,
                            })
                        end
                    else
                        fallback()
                    end
                end),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

            },
            sources = cmp.config.sources({
                { name = "copilot", group_index = 1, priority = 1000, max_item_count = 2 },
                { name = "nvim_lsp", group_index = 2, priority = 900 },
                { name = "luasnip", group_index = 2, priority = 800 }, -- For luasnip users.
                { name = "buffer", group_index = 3, priority = 700 },
            }),
            sorting = {
                priority_weight = 2,
                comparators = {
                    -- absolute rule: copilot always above non-copilot
                    function(entry1, entry2)
                        local c1 = entry1.source.name == "copilot"
                        local c2 = entry2.source.name == "copilot"
                        if c1 ~= c2 then
                            return c1 -- true if entry1 is copilot
                        end
                    end,

                    require("copilot_cmp.comparators").prioritize,

                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    cmp.config.compare.recently_used,
                    cmp.config.compare.locality,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },

        })

    end,
},
}
