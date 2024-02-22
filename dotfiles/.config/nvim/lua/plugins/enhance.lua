return {
  { "nvim-lua/plenary.nvim" },

  {
    "folke/flash.nvim",
    config = function()
      require("config.flash-config")
    end,
    keys = {
      "/",
      { "f", mode = { "n", "x" } },
      { "F", mode = { "n", "x" } },
      { "S", mode = { "o", "x" } },
      { "r", mode = { "o" } },
      { "R", mode = { "o", "x" } },
    },
  },

  {
    "max397574/better-escape.nvim",
    keys = {
      { "jk", mode = "i" },
      { "jj", mode = "i" },
      { "kk", mode = "i" },
    },
    opts = {
      -- Press `jk`, "kj",`jj`, "kk" to escape from insert mode
      mapping = { "jk", "kj", "jj", "kk" },
    },
  },

  {
    "echasnovski/mini.pairs",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      modes = { insert = true, command = true },
    },
    config = true,
  },

  {
    "echasnovski/mini.surround",
    keys = {
      { "s", mode = { "n", "v" } },
      "ds",
      "cs",
    },
    config = function()
      require("config.surround-config")
    end,
  },

  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("config.colorizer-config")
    end,
  },

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateRight",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
    },
  },

  {
    "nvimdev/hlsearch.nvim",
    event = "BufReadPost",
    config = true,
  },

  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "andymass/vim-matchup",
        config = function()
          require("config.matchup-config")
        end,
      },
    },
    config = function()
      require("config.treesitter-config")
    end,
  },
}
