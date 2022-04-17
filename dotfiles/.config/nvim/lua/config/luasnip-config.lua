local ls = require("luasnip")
local types = require("luasnip.util.types")

local consts = require("utils.constants")

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
  paths = consts.files.snippets,
})
