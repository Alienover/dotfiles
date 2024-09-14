local utils = require("custom.utils")

-- Options
vim.cmd.setlocal("nocursorline nonumber norelativenumber")

vim.wo.statuscolumn = ""

-- Keymaps
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr }

local escape = "<C-\\><C-n>"

local mappings = {}
for _, mapping in ipairs({
  { "<ESC>", escape },
  { "jk", escape },
  { "<c-w>h", escape .. "<C-w>h" },
  { "<c-w>j", escape .. "<C-w>j" },
  { "<c-w>k", escape .. "<C-w>k" },
  { "<c-w>l", escape .. "<C-w>l" },
}) do
  local lhs, rhs = unpack(mapping)

  table.insert(mappings, { "t", lhs, rhs, opts })
end

utils.create_keymaps(mappings)
