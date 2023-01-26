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
    "kyazdani42/nvim-web-devicons",
    opts = {
      default = true,
    },
  },

  { -- Statusline
    "hoob3rt/lualine.nvim",
    lazy = false,
    config = function()
      require("config.lualine-config")
    end,
    dependencies = {
      "kyazdani42/nvim-web-devicons",
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
