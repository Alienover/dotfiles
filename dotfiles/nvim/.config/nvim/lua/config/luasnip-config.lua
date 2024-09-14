local ls = require("luasnip")
local types = require("luasnip.util.types")

local utils = require("custom.utils")
local consts = require("custom.constants")

ls.config.set_config({
  history = true,
  updateevents = "TextChanged, TextChangedI",
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<--", "Error" } },
      },
    },
  },
})

require("luasnip.loaders.from_lua").lazy_load({
  paths = { consts.files.snippets },
})

-- Expand the current snippet or jump to the next item within the snippet
local keymaps = {
  -- Snippet Navigate
  {
    { "i", "s" },
    "<C-l>",
    function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end,
  },
  {
    { "i", "s" },
    "<C-h>",
    function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end,
  },

  -- Choice Snippet
  {
    "i",
    "<C-j>",
    function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end,
  },
}

utils.create_keymaps(keymaps)
