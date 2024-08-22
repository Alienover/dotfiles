local consts = require("utils.constants")

return {
  { -- Keep Window on Buffer Delete - Improved - (lua ver.)
    "@local/kwbdi.nvim",
    cmd = { "KWBufDel" },
    config = true,
  },

  { -- Customized winbar with file path and document symbols
    "@local/winbar.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      excluded_fn = function()
        -- INFO: Display the winbar info from the diff plugin itself
        return vim.opt.diff:get()
      end,
      excluded_filetypes = consts.special_filetypes.excluded_winbar,
    },
  },
}
