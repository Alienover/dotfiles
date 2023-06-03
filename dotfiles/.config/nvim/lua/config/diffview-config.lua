local config = {
  default_args = {
    DiffviewOpen = { "--imply-local" },
    DiffviewFileHistory = { "--base=LOCAL" },
  },
  view = {
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff4_mixed",
      disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
      winbar_info = true, -- See ':h diffview-config-view.x.winbar_info'
    },
  },
}

require("diffview").setup(config)
