-- Reference:
-- https://github.com/hrsh7th/nvim-cmp

local cmp = require "cmp"

-- Reference:
-- https://github.com/onsails/lspkind-nvim/blob/521e4f9217d9bcc388daf184be8b168233e8aeed/lua/lspkind/init.lua#L130-L148
local function cmp_format(opts)
    if opts == nil then
        opts = {}
    end

    return function(entry, vim_item)
        if opts.menu ~= nil then
            vim_item.menu = opts.menu[entry.source.name]
        end

        if opts.maxwidth ~= nil then
            vim_item.abbr = string.sub(vim_item.abbr, 1, opts.maxwidth)
        end

        return vim_item
    end
end

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
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-n>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert}),
            ["<C-p>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}),
            ["<Down>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
            ["<Up>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm(
                {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true
                }
            ),
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
            end
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
            {name = "buffer"},
            {name = "path"},
            {name = "calc"},
            {name = "emoji"}
        },
        formatting = {
            format = cmp_format(
                {
                    menu = ({
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        treesitter = "[[Treesitter]]",
                        vsnip = "[[VSnip]]",
                        nvim_lua = "[Lua]",
                        path = "[[Path]]",
                        calc = "[[Calc]]",
                        emoji = "[[Emoji]]"
                    })
                }
            )
        }
    }
)
