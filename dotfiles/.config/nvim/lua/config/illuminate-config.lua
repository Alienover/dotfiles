require("illuminate").configure({
  filetypes_denylist = {
    "git.nvim",
    "checkhealth",
    "help",
    "lspsagafinder",
  },
  under_cursor = false,
  modes_allowlist = { "n" },
})
