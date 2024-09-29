local M = {
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	settings = {
		typescript = {
			-- taken from https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#inlay-hints-textdocumentinlayhint
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
}

return M
