local consts = require("utils.constants")

return {
  { "nvim-lua/plenary.nvim" },

  {
    "folke/flash.nvim",
    config = function()
      require("config.flash-config")
    end,
    keys = {
      { "<c-f>", mode = "c" },
      { "f", mode = { "n", "x" } },
      { "F", mode = { "n", "x" } },
      { "S", mode = { "o", "x" } },
      { "r", mode = { "o" } },
      { "R", mode = { "o", "x" } },
    },
  },

  {
    "@local/better_hjkl.nvim",
    event = { "CursorMoved" },
    opts = {
      escape = {
        -- Press `jk`, "kj",`jj`, "kk" to escape from insert mode
        mapping = { "jk", "kj", "jj", "kk" },
      },
      discipline = {
        excluded_filetypes = consts.special_filetypes.excluded_cowboy,
      },
    },
    config = true,
  },

  {
    "max397574/better-escape.nvim",
    tag = "v1.0.0",
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
    "alexghergh/nvim-tmux-navigation",
    keys = {
      { "<C-w>h", "<CMD>NvimTmuxNavigateLeft<CR>", desc = "Focus Left Pane" },
      { "<C-w>l", "<CMD>NvimTmuxNavigateRight<CR>", desc = "Focus Right Pane" },
      { "<C-w>j", "<CMD>NvimTmuxNavigateDown<CR>", desc = "Focus Down Pane" },
      { "<C-w>k", "<CMD>NvimTmuxNavigateUp<CR>", desc = "Focus Up Pane" },
    },
    opts = {
      keybindings = {
        last_active = nil,
        next = nil,
      },
    },
  },

  {
    "nvimdev/hlsearch.nvim",
    event = "BufReadPost",
    config = true,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    config = function()
      require("config.autotag-config")
    end,
  },

  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
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

  {
    "tzachar/highlight-undo.nvim",
    keys = { "u", "<C-r>" },
    config = true,
  },
}
