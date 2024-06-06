local consts = require("utils.constants")

return {
  { -- Provides the `go_def` and `go_back` with marks
    -- FIXME: Deprecated
    "@local/lsp-marks.nvim",
    enabled = false,
    dev = true,
    config = true,
  },

  { -- Descipline in cursor moving
    "@local/discipline.nvim",
    -- FIXME: key binding conflicts with the mapping for 'j', 'k' to 'gj', 'gk'
    enabled = false,
    dev = true,
    cmd = { "CowboyToggle" },
    event = { "CursorMoved" },
    config = true,
  },

  { -- Keep Window on Buffer Delete - Improved - (lua ver.)
    "@local/kwbdi.nvim",
    dev = true,
    cmd = { "KWBufDel" },
    config = true,
  },

  { -- Customized winbar with file path and document symbols
    "@local/winbar.nvim",
    dev = true,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      excluded_fn = function()
        -- INFO: Display the winbar info from the diff plugin itself
        return vim.opt.diff:get()
      end,
      excluded_filetypes = consts.special_filetypes.excluded_winbar,
    },
  },
}
