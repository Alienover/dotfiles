return {
  {
    "nvimdev/lspsaga.nvim",
    event = { "LspAttach" },
    cmd = { "Lspsaga" },
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
    tag = "legacy",
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
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformFormat", "ConformToggle" },
    config = function()
      require("config.conform-config")
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("config.lint-config")
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason" },
    event = "VeryLazy",
    build = ":MasonUpdate",
    config = function()
      require("config.mason-config")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",

      "j-hui/fidget.nvim", -- Provides LSP progress widget

      "folke/neodev.nvim", -- Provides Lua setup for neovim

      "@local/lsp-marks.nvim", -- Provide the `go_def` and `go_back` with marks
    },
    config = function()
      require("lsp")
    end,
  },
}
