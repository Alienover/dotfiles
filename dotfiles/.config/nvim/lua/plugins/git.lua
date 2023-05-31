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
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      default_args = {
        DiffviewOpen = { "--imply-local" },
      },
    },
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
