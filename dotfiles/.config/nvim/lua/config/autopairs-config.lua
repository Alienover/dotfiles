-- Reference:
-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/autopairs.lua

require("nvim-autopairs").setup({
  ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
  check_ts = true,
  fast_wrap = {
    map = "<C-e>",
    offset = 0, -- Offset from pattern match
  },
})
