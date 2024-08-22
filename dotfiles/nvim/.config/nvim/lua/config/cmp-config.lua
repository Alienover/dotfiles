-- Reference:
-- https://github.com/hrsh7th/nvim-cmp

local cmp = require("cmp")
local cmp_config = require("cmp.config")
local neogen = require("neogen")

local utils = require("utils")
local icons = require("utils.icons")

---@param c table
---@return cmp.ConfigSchema
local extend_config = function(c)
  return vim.tbl_extend("force", cmp_config.global, c)
end

---Wrapper for cmp sources in configuring source structure, formating name
local registery = setmetatable({
  __sources = {},

  __display = setmetatable({
    nvim_lsp = "[LSP]",
    luasnip = "[LuaSnip]",
    nvim_lua = "[Lua]",
    cmdline = "[CMD]",
  }, {
    __index = function(_, key)
      local first, rest = string.sub(key, 1, 1), string.sub(key, 2)
      return string.format("[%s%s]", string.upper(first), rest)
    end,
  }),

  __init = function(self, name)
    local display, sources = self.__display, self.__sources

    if not sources[name] then
      local tmp = { name = name }

      -- Formatter
      function tmp:format()
        return display[name]
      end

      -- Config Extend
      function tmp:extend(opts)
        local copy = vim.deepcopy(self)
        opts = opts or {}

        for k, v in pairs(opts) do
          copy[k] = v
        end

        return copy
      end

      sources[name] = vim.deepcopy(tmp)
    end

    return sources[name]
  end,
}, {
  __index = function(state, name)
    return state:__init(name)
  end,
})

--- Returns the CompletedItem only containing text without icon
--- @param _ cmp.Entry
--- @param vim_item vim.CompletedItem
--- @return vim.CompletedItem
local simple_format = function(_, vim_item)
  vim_item.kind = nil
  return vim_item
end

cmp.setup(extend_config({
  snippet = {
    expand = function(args)
      -- For `luasnip` user.
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  sorting = {
    -- INFO: Try use `recently-used` to sort the results
    comparators = cmp.config.compare.recently_used,
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
      if neogen.jumpable(-1) then
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
  sources = cmp.config.sources(
    -- Group index: 1
    {
      registery.nvim_lsp, -- LSP

      registery.luasnip, -- For luasnip user.
    },
    -- Group index: 2
    {
      -- Utilities
      registery.path,
      registery.buffer:extend({ keyword_length = 5 }),
    }
  ),
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", icons.get("lsp", vim_item.kind))

      vim_item.menu = registery[entry.source.name]:format()

      return vim_item
    end,
  },
  experimental = {
    native_menu = false,
    ghost_text = {
      hl_group = "Comment",
    },
  },
}))

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  { "/", "?" },
  extend_config({
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      registery.buffer,
    },
    formatting = {
      format = simple_format,
    },
  })
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  ":",
  extend_config({
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ registery.path }, {
      registery.cmdline:extend({
        ignore_cmds = { "Man", "!" },
        keyword_length = 2,
      }),
    }),
    formatting = {
      format = simple_format,
    },
  })
)

-- If a file is too large, I don't want to add to it's cmp sources treesitter, see:
-- https://github.com/hrsh7th/nvim-cmp/issues/1522
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function(t)
    if not utils.buffer_is_big(t.buf) then
      local sources = vim.F.npcall(function()
        return require("cmp.core").sources
      end, nil)

      if sources then
        sources[#sources + 1] = registery.treesitter

        cmp.setup.buffer(extend_config({
          sources = sources,
        }))
      end
    end
  end,
})
