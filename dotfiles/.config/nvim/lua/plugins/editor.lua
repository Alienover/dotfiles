local consts = require("utils.constants")

return {
  {
    "folke/which-key.nvim",
    keys = { "<space>" },
    cmd = { "WhichKey" },
    config = function()
      require("config.which-key-config")
    end,
  },

  { -- Files browser
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    -- event = "VimEnter",
    config = function()
      require("config.telescope-config")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },

  {
    "kevinhwang91/rnvimr",
    keys = { "<C-f>" },
    cmd = { "RnvimrToggle" },
    config = function()
      require("config.rnvimr-config")
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = { "gcc", "gbc", { "gc", mode = "x" } },
    opts = {
      -- ignores empty lines
      ignore = "^$",
    },
  },

  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    config = function()
      require("config.todo-config")
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  { -- Snippets
    "L3MON4D3/LuaSnip",
    config = function()
      require("config.luasnip-config")
    end,
  },

  {
    dir = consts.local_plugins.fzf,
    cmd = { "FZFFiles" },
    dependencies = { { "junegunn/fzf", build = "./install --all" } },
    config = true,
  },

  {
    "janko-m/vim-test",
    cmd = { "TestFile", "TestNearest" },
  },

  {
    "NTBBloodbath/rest.nvim",
    ft = { "http" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.rest-config")
    end,
  },

  {
    dir = consts.local_plugins.winbar,
    event = { "BufReadPost" },
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },

  {
    "folke/noice.nvim",
    lazy = false,
    config = function()
      require("config.noice-config")
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost" },
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require("config.ufo-config")
    end,
  },

  {
    "danymat/neogen",
    cmd = { "Neogen" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },

  {
    "smjonas/inc-rename.nvim",
    event = { "BufReadPost" },
    config = true,
  },
}
