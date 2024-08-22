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
    "echasnovski/mini.icons",
    config = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  { -- Status Line
    "hoob3rt/lualine.nvim",
    event = "VeryLazy",
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

  { -- UI for messages, cmdline and the popupmenu
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require("config.noice-config")
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      { "MunifTanjim/nui.nvim", module = "nui" },

      {
        "rcarriga/nvim-notify",
        module = "notify",
        opts = {
          background_colour = "#000000",
        },
      },
    },
  },
}
