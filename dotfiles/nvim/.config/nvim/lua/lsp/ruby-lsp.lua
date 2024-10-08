local mason_registry = require("mason-registry")

local M = {
	cmd = mason_registry.get_package("ruby-lsp"):get_install_path(),
}

return M
