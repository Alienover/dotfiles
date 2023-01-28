local consts = require("utils.constants")

return {
  {
    "glepnir/lspsaga.nvim",
    event = "BufReadPost",
    config = function()
      require("config.saga-config")
    end,
  },

  {
    "smjonas/inc-rename.nvim",
    event = "BufReadPost",
    config = true,
    dependencies = { "neovim/nvim-lspconfig" },
  },

  {
    "neovim/nvim-lspconfig",
    event = "VimEnter",
    config = function()
      require("lsp")
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/null-ls.nvim",

      {
        "j-hui/fidget.nvim",
        config = function()
          require("config.fidget-config")
        end,
      },

      {
        "folke/lsp-colors.nvim",
        opts = {},
      },

      { -- Provides the `go_def` and `go_back` with marks
        dir = consts.local_plugins.marks,
        config = true,
      },
    },
  },

  {
    "nvim-treesitter/playground",
    cmd = {
      "TSHighlightCapturesUnderCursor",
      "TSPlaygroundToggle",
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter-config")
    end,
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-refactor",
      {
        "andymass/vim-matchup",
        config = function()
          require("config.matchup-config")
        end,
      },
    },
  },

  { -- Additional text objects via treesitter
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "BufReadPost",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
