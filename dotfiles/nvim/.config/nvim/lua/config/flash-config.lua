local utils = require("custom.utils")
local flash = require("flash")

flash.setup({
  prompt = {
    enabled = false,
  },
  modes = {
    char = {
      jump_labels = true,
    },
    search = {
      enabled = false,
    },
  },
})

utils.create_keymaps({
  {
    { "o", "x" },
    "S",
    function()
      flash.treesitter()
    end,
    "Flash Treesitter",
  },

  {
    "o",
    "r",
    function()
      flash.remote()
    end,
    "Remote Flash",
  },

  {
    { "o", "x" },
    "R",
    function()
      flash.treesitter_search()
    end,
    "Treesitter Search",
  },

  {
    { "c" },
    "<C-f>",
    function()
      flash.toggle()
    end,
    "Toggle Flash Search",
  },
})
