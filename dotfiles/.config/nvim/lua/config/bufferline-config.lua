-- Reference
-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/bufferline.lua

require("bufferline").setup({
  options = {
    theme = "tokyonight",
    -- mappings = true,
    show_close_icon = false,
    show_buffer_close_icons = false,
    diagnostics = "nvim_lsp",
    always_show_bufferline = true,
    separator_style = "slant",
    diagnostics_indicator = function(count)
      return "(" .. count .. ")"
    end,
  },
})
