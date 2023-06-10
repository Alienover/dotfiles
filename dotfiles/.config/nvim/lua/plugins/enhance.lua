return {
  { "nvim-lua/plenary.nvim" },

  { "ggandor/leap.nvim" },

  { -- Keep Window on Buffer Delete - Improved - (lua ver.)
    "@local/kwbdi.nvim",
    dev = true,
    cmd = { "KWBufDel" },
    config = true,
  },

  {
    "max397574/better-escape.nvim",
    keys = {
      { "jk", mode = "i" },
      { "jj", mode = "i" },
      { "kk", mode = "i" },
    },
    opts = {
      -- Press `jk`, `jj` to escape from insert mode
      mapping = { "jk", "jj" },
    },
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
    event = "BufReadPost",
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

  { -- FIXME: Need to setup a payment method in OpenAI to access the API
    "madox2/vim-ai",
    enabled = false,
    cmd = { "AI", "AIEdit", "AIChat" },
    config = function()
      require("config.ai-config")
    end,
  },
}
