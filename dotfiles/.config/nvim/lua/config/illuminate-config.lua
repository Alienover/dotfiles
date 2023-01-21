require("illuminate").configure({
  filetypes_denylist = {
    "git.nvim",
    "checkhealth",
    "help",
    "lspsagafinder",
    "lazy",
  },
  under_cursor = false,
  modes_allowlist = { "n" },
})
