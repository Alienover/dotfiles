-- Reference:
-- https://github.com/hrsh7th/nvim-cmp

local cmp = require "cmp"
local lspkind = require "lspkind"

cmp.setup(
    {
        snippet = {
            expand = function(args)
                -- For `vsnip` user.
                vim.fn["vsnip#anonymous"](args.body)

                -- For `luasnip` user.
                -- require('luasnip').lsp_expand(args.body)

                -- For `ultisnips` user.
                -- vim.fn["UltiSnips#Anon"](args.body)
            end
        },
        mapping = {
            -- Scrolling
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            -- Navigating
            ["<C-n>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert}),
            ["<C-p>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}),
            ["<Down>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
            ["<Up>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
            ["<Tab>"] = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end,
            ["<S-Tab>"] = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end,
            -- Completion
            ["<C-e>"] = cmp.mapping.close(),
            ["<C-o>"] = cmp.mapping.complete(),
            ["<C-l>"] = cmp.mapping(
                function(fallback)
                    if cmp.core.view:get_selected_entry() then
                        cmp.confirm()
                    else
                        fallback()
                    end
                end,
                {"i", "s"}
            ),
            ["<CR>"] = cmp.mapping.confirm(
                {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true
                }
            )
        },
        sources = {
            -- LSP
            {name = "nvim_lsp"},
            {name = "treesitter"},
            {name = "nvim_lua"},
            -- For vsnip user.
            {name = "vsnip"},
            -- For luasnip user.
            -- { name = 'luasnip' },

            -- For ultisnips user.
            -- { name = 'ultisnips' },

            -- Utilities
            {name = "path"},
            {name = "calc"},
            {name = "emoji"},
            {name = "buffer", keyword_length = 5}
        },
        formatting = {
            format = lspkind.cmp_format(
                {
                    -- preset = "codicons",
                    with_text = false,
                    menu = ({
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        treesitter = "[Treesitter]",
                        vsnip = "[VSnip]",
                        nvim_lua = "[Lua]",
                        path = "[Path]",
                        calc = "[Calc]",
                        emoji = "[Emoji]"
                    })
                }
            )
        },
        experimental = {
            native_menu = false,
            ghost_text = true
        }
    }
)
