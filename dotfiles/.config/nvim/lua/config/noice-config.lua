require("notify").setup({
  background_colour = "#00000000",
})

-- require("lsp-notify").setup({
--   notify = require("notify"),
-- })

require("noice").setup({
  presets = { inc_rename = true },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    progress = {
      enabled = false,
    },
    hover = {
      enabled = false,
    },
  },
})
