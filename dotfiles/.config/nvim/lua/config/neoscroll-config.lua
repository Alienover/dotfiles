-- Reference
-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/scroll.lua

require("neoscroll").setup({
  hide_cursor = false,
  mappings = { "<C-u>", "<C-d>", "zz" },
})

local map = {}

map["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "80" } }
map["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "80" } }
map["zz"] = { "zz", { "150" } }

require("neoscroll.config").set_mappings(map)
