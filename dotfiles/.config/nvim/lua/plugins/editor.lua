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
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("config.telescope-config")
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

  { -- Highlight keywords like todo, fix, and info
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.todo-config")
    end,
  },

  { -- Snippets
    "L3MON4D3/LuaSnip",
    config = function()
      require("config.luasnip-config")
    end,
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
    "nvim-neorg/neorg",
    ft = { "norg" },
    cmd = { "Neorg" },
    build = ":Neorg sync-parsers",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neorg/neorg-telescope",
    },
    config = function()
      require("config.neorg-config")
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = { "markdown" },
    config = function()
      require("config.markdown-config")
    end,
  },
}
