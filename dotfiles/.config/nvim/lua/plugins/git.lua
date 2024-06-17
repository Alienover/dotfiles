return {
  {
    "alienover/git.nvim",
    cmd = { "Git", "GitBlame" },
    keys = { { "<space>go", mode = { "n", "x" } }, "<space>gP" },
    config = function()
      require("config.git-config")
    end,
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
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.gitsigns-config")
    end,
  },
  {
    "Alienover/blame.nvim",
    cmd = { "BlameToggle" },
    opts = {
      date_format = "%Y-%m-%d %H:%M",
    },
  },
}
