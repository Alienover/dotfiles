local util = require("lspconfig.util")

local M = {
	cmd = { "bundle", "exec", "rubocop", "--lsp" },
	root_dir = util.root_pattern(".rubocop.yml"),
}

return M
