require("filetype").setup({
  -- overrides the filetype or function for filetype
  -- See https://github.com/nathom/filetype.nvim#customization
  overrides = {
    extensions = {
      json = "jsonc",
    },
    literal = {
      [".gitignore"] = "conf",
    },
  },
})
