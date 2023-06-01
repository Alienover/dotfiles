return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("config.saga-config")
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "smjonas/inc-rename.nvim",
    cmd = { "IncRename" },
    config = true,
    dependencies = { "neovim/nvim-lspconfig" },
  },

  {
    "j-hui/fidget.nvim",
    opts = {
      text = {
        spinner = "meter",
      },
      window = {
        relative = "editor",
        blend = 0,
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function()
      require("lsp")
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "j-hui/fidget.nvim",

      {
        "folke/lsp-colors.nvim",
        opts = {},
      },

      { -- Provides the `go_def` and `go_back` with marks
        "@local/lsp-marks.nvim",
        dev = true,
        config = true,
      },
    },
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
