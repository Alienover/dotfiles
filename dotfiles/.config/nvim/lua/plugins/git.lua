return {
  {
    "dinhhuy258/git.nvim",
    cmd = { "Git", "GitBlame" },
    keys = { "<space>go", "<space>gP" },
    opts = {
      default_mappings = false,
      keymaps = {
        browse = "<space>go",
        open_pull_request = "<space>gP",
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.diffview-config")
    end,
  },

  { -- Git Gutter
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.gitsigns-config")
    end,
  },
}
