local consts = require("utils.constants")

return {
  {
    "glepnir/lspsaga.nvim",
    event = "BufReadPre",
    config = function()
      require("config.saga-config")
    end,
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

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter-config")
    end,
    dependencies = {
      "windwp/nvim-ts-autotag",
      { "andymass/vim-matchup", event = "CursorMoved" },
    },
  },
}
