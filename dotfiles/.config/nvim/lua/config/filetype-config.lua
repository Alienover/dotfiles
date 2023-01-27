local config = {
  -- overrides the filetype or function for filetype
  -- See https://github.com/nathom/filetype.nvim#customization
  overrides = {
    extensions = {
      json = "jsonc",
      tmux = "tmux",
    },
    literal = {
      [".gitignore"] = "conf",
    },
    function_extensions = {
      ["pdf"] = function()
        vim.bo.filetype = "pdf"

        -- Open in PDF previewer automatically
        vim.fn.jobstart(string.format('open "%s"', vim.fn.expand("%")))
      end,
    },
  },
}

require("filetype").setup(config)
