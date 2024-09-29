local M = {
	filetypes = { "go", "gomod" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			-- takend from https://github.com/golang/tools/blob/3f74dc588604cd149e78e4724603acca94f23dbd/gopls/doc/inlayHints.md
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = false,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}

-- require "lspconfig".gopls.setup(M)
return M
