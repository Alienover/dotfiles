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
    keys = { "s", "ds", "cs" },
    config = function()
      require("mini.surround").setup({
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          add = "s", -- Add surrounding in Normal and Visual modes
          delete = "ds", -- Delete surrounding
          replace = "cs", -- Replace surrounding

          -- Disabled
          find = "", -- Find surrounding (to the right)
          find_left = "", -- Find surrounding (to the left)
          highlight = "", -- Highlight surrounding
          update_n_lines = "", -- Update `n_lines`
          suffix_last = "", -- Suffix to search with "prev" method
          suffix_next = "", -- Suffix to search with "next" method
        },
      })
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
    lazy = false,
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
