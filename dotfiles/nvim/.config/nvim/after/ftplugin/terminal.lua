-- Options
vim.opt_local.cursorline = false
vim.opt_local.number = false
vim.opt_local.relativenumber = false

vim.wo.statuscolumn = ""

-- Keymaps
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr }

local escape = "<C-\\><C-n>"

for _, mapping in ipairs({
	{ "<ESC>", escape },
	{ "jk", escape },
	{ "<c-w>h", escape .. "<C-w>h" },
	{ "<c-w>j", escape .. "<C-w>j" },
	{ "<c-w>k", escape .. "<C-w>k" },
	{ "<c-w>l", escape .. "<C-w>l" },
}) do
	local lhs, rhs = unpack(mapping)

	vim.keymap.set("t", lhs, rhs, opts)
end
