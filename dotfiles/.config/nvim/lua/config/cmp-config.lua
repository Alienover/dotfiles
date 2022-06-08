-- Reference:
-- https://github.com/hrsh7th/nvim-cmp

local cmp = require("cmp")
local constants = require("utils.constants")

local icons = constants.icons
local kind_icons = icons.kind

local config = {
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      -- vim.fn["vsnip#anonymous"](args.body)

      -- For `luasnip` user.
      require("luasnip").lsp_expand(args.body)

      -- For `ultisnips` user.
      -- vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = {
    -- Scrolling
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    -- Navigating
    ["<C-n>"] = cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Insert,
    }),
    ["<C-p>"] = cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Insert,
    }),
    ["<Down>"] = cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Select,
    }),
    ["<Up>"] = cmp.mapping.select_prev_item({
      behavior = cmp.SelectBehavior.Select,
    }),
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
    -- ["<C-l>"] = cmp.mapping(function(fallback)
    --   if cmp.core.view:get_selected_entry() then
    --     cmp.confirm()
    --   else
    --     fallback()
    --   end
    -- end, {
    --   "i",
    --   "s",
    -- }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
  sources = {
    -- LSP
    { name = "nvim_lsp" },
    { name = "treesitter" },
    { name = "nvim_lua" },
    -- For vsnip user.
    -- { name = "vsnip" },
    -- For luasnip user.
    { name = "luasnip" },

    -- For ultisnips user.
    -- { name = 'ultisnips' },

    -- Utilities
    { name = "path" },
    { name = "calc" },
    { name = "emoji" },
    { name = "buffer", keyword_length = 5 },
  },
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])

      if entry.source.name == "cmp_tabnine" then
        vim_item.kind = icons.misc.Robot
      end

      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        treesitter = "[Treesitter]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        path = "[Path]",
        calc = "[Calc]",
        emoji = "[Emoji]",
      })[entry.source.name]
      return vim_item
    end,
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
}

cmp.setup(config)
