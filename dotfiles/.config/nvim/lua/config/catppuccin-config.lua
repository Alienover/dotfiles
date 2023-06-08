local config = {
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  transparent_background = true,
  term_colors = true,
  integrations = {
    cmp = true,
    fidget = true,
    gitsigns = true,
    leap = true,
    lsp_saga = true,
    markdown = true,
    mason = true,
    noice = true,
    notify = true,
    telescope = true,
    treesitter = true,
    treesitter_context = true,
    which_key = true,
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
  custom_highlights = function(colors)
    return {
      FoldedVirtualText = { fg = colors.overlay0, style = { "bold", "italic" } },
      -- Replace the `underline` with `undercurl`
      DiagnosticUnderlineError = { style = { "undercurl" } },
      DiagnosticUnderlineWarn = { style = { "undercurl" } },
      DiagnosticUnderlineInfo = { style = { "undercurl" } },
      DiagnosticUnderlineHint = { style = { "undercurl" } },

      TabLineSel = { bg = colors.red },

      -- INFO: Work around https://github.com/neovim/neovim/issues/9800
      CursorLine = { ctermfg = "White" },

      ["@neorg.tags.ranged_verbatim.code_block"] = { bg = colors.surface0 },
    }
  end,
}

require("catppuccin").setup(config)

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin-mocha")
