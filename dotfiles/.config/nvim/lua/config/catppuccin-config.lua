local config = {
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  transparent_background = true,
  term_colors = true,
  integrations = {
    cmp = true,
    mason = true,
    noice = false,
    fidget = true,
    notify = true,
    gitsigns = true,
    which_key = true,
    telescope = true,
    treesitter = true,
    treesitter_context = true,
  },
  native_lsp = {
    enabled = true,
    virtual_text = {
      errors = { "italic" },
      hints = { "italic" },
      warnings = { "italic" },
      information = { "italic" },
    },
  },
  highlight_overrides = {
    all = function()
      return {
        -- Replace the `underline` with `undercurl`
        DiagnosticUnderlineError = { style = { "undercurl" } },
        DiagnosticUnderlineWarn = { style = { "undercurl" } },
        DiagnosticUnderlineInfo = { style = { "undercurl" } },
        DiagnosticUnderlineHint = { style = { "undercurl" } },
      }
    end,
  },
}

require("catppuccin").setup(config)

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin-mocha")
