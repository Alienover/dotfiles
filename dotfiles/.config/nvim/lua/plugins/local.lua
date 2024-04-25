local consts = require("utils.constants")

return {
  { -- Provides the `go_def` and `go_back` with marks
    "@local/lsp-marks.nvim",
    dev = true,
    config = true,
  },

  { -- Keep Window on Buffer Delete - Improved - (lua ver.)
    "@local/kwbdi.nvim",
    dev = true,
    cmd = { "KWBufDel" },
    config = true,
  },

  { -- Descipline in cursor moving
    "@local/discipline.nvim",
    dev = true,
    cmd = { "CowboyToggle" },
    event = { "CursorMoved" },
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
