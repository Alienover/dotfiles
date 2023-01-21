local utils = require("utils")
local consts = require("utils.constants")

return {
  { "nvim-lua/plenary.nvim" },
  { -- speed up neovim!
    "nathom/filetype.nvim",
    lazy = false,
    config = function()
      require("config.filetype-config")
    end,
  },
  {
    dir = consts.local_plugins.kwbdi,
    cmd = { "KWBufDel" },
    config = true,
  },
  {
    "max397574/better-escape.nvim",
    keys = { { "jk", mode = "i" } },
    opts = {
      -- Press `jk` to escape from insert mode
      mapping = "jk",
    },
  },

  {
    "RRethy/vim-illuminate",
    event = "CursorMoved",
    config = function()
      require("config.illuminate-config")
    end,
  },

  {
    "echasnovski/mini.surround",
    keys = { "sa", "sd", "sr" },
    config = function()
      require("mini.surround").setup()
    end,
  },

  { -- Handle `.editorconfig` settings
    "editorconfig/editorconfig-vim",
    enabled = utils.has_0_9 ~= true,
    event = "BufEnter",
  },

  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("config.colorizer-config")
    end,
  },
}
