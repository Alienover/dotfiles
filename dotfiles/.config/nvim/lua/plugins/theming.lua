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

  { -- Status Line
    "hoob3rt/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("config.lualine-config")
    end,
  },

  { -- Tabs
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "catppuccin" },
    config = function()
      require("config.bufferline-config")
    end,
  },
}
