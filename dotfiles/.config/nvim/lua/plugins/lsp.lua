return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.saga-config")
    end,
  },

  {
    "smjonas/inc-rename.nvim",
    event = "LspAttach",
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
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim", -- Provides the linters and formatters

      -- LSP server installer and manager
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      "j-hui/fidget.nvim", -- Provides LSP progress widget

      "folke/neodev.nvim", -- Provides Lua setup for neovim

      { -- Provides the `go_def` and `go_back` with marks
        "@local/lsp-marks.nvim",
        dev = true,
        config = true,
      },

      -- FIXME: remove it after few weeks monitoring
      -- {
      --   "folke/lsp-colors.nvim",
      --   opts = {},
      -- },
    },
    config = function()
      require("lsp")
    end,
  },
}
