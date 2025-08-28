local consts = require("custom.constants")

---@type LazySpec
return {
	{
		"@local/better_hjkl.nvim",
		event = { "CursorMoved" },
		opts = {
			discipline = {
				excluded_filetypes = consts.special_filetypes.excluded_cowboy,
			},
		},
	},

	{ -- Customized winbar with file path and document symbols
		"@local/winbar.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			excluded_fn = function()
				-- INFO: Exclude those non-exsited files
				return not vim.uv.fs_stat(vim.fn.expand("%:p"))
			end,
			excluded_filetypes = consts.special_filetypes.excluded_winbar,
		},
	},
}
