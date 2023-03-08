-- Reference:
-- https://github.com/hrsh7th/nvim-cmp

local cmp = require("cmp")
local neogen = require("neogen")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

local constants = require("utils.constants")

local icons = constants.icons
local kind_icons = icons.kind

local config = {
  snippet = {
    expand = function(args)
      -- For `luasnip` user.
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
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
    ["<Tab>"] = cmp.mapping(function(fallback)
      if neogen.jumpable() then
        neogen.jump_next()
      elseif cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if neogen.jumpable(true) then
        neogen.jump_prev()
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    -- Completion
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-o>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  }),
  sources = cmp.config.sources({
    -- LSP
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },

    { name = "treesitter" },

    -- For luasnip user.
    { name = "luasnip" },

    -- Utilities
    { name = "path" },
    { name = "calc" },
    { name = "emoji" },
    { name = "buffer", keyword_length = 5 },

    -- Neorg support
    { name = "neorg" },
  }),
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

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
