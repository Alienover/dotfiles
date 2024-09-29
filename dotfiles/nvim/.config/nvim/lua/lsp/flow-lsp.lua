-- Reference
-- https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/lua/lspconfig/flow.lua

local M = {
	cmd = { "npx", "--no-install", "flow", "lsp" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx" },
	root_dir = function(startpath)
		return vim.fs.root(startpath, ".flowconfig")
	end,
}

return M
