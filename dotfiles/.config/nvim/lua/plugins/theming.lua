return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("config.theme-config")
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
    lazy = false,
    config = function()
      require("config.bufferline-config")
    end,
  },
}
