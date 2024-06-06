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
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("lsp")
    end,
  },
}
