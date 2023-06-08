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
    config = function()
      require("config.telescope-config")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
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
    "@local/fzf-finder.nvim",
    dev = true,
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
    "@local/winbar.nvim",
    dev = true,
    event = { "BufReadPost" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      excluded_fn = function()
        -- INFO: Display the winbar info from the diff plugin itself
        return vim.opt.diff:get()
      end,
      excluded_filetypes = consts.special_filetypes.excluded_winbar,
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require("config.noice-config")
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",

      "rcarriga/nvim-notify",

      "nvim-treesitter/nvim-treesitter",
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
