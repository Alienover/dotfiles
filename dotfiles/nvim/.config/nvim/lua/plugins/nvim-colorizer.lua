---@type LazySpec
return {
	-- TODO: replace it with the built-in `vim.lsp.document_color` after nvim 0.12 launched
	-- Refer to https://github.com/neovim/neovim/pull/33440
	{
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			["*"] = {
				RRGGBBAA = true,
				css = true,
				css_fn = true,
			},
			"!notify",
			"!lazy",
			"!markdown",
		},
	},
}
