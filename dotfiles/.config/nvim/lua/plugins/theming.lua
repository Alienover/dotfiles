return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("config.catppuccin-config")
    end,
  },

  { -- Icons
    "nvim-tree/nvim-web-devicons",
    opts = {
      default = true,
    },
  },

  { -- Statusline
    "hoob3rt/lualine.nvim",
    event = { "BufReadPre" },
    config = function()
      require("config.lualine-config")
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },

  { -- Tabs
    "akinsho/bufferline.nvim",
    event = { "VimEnter" },
    dependencies = { "catppuccin" },
    config = function()
      require("config.bufferline-config")
    end,
  },
}
