return {
  { "nvim-lua/plenary.nvim" },

  {
    "@local/kwbdi.nvim",
    dev = true,
    cmd = { "KWBufDel" },
    config = true,
  },
  {
    "max397574/better-escape.nvim",
    keys = { { "jk", mode = "i" } },
    opts = {
      -- Press `jk` to escape from insert mode
      mapping = "jk",
    },
  },

  {
    "echasnovski/mini.surround",
    keys = { "s", { "s", mode = "v" }, "ds", "cs" },
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
    "ggandor/leap.nvim",
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
    event = { "BufReadPost" },
    config = true,
  },

  -- Need to setup a payment method in OpenAI to access the API
  {
    "madox2/vim-ai",
    enabled = false,
    cmd = { "AI", "AIEdit", "AIChat" },
    config = function()
      require("config.ai-config")
    end,
  },
}
