---@type LazySpec
return {
	{
		"@local/better_hjkl.nvim",
		event = { "CursorMoved" },
		opts = {
			discipline = {
				excluded_filetypes = {
					"lazy",
					"mason",
					"blame",
					"help",
					"noice",
					"http",
					"oil",
				},
			},
		},
	},

	{ -- Customized winbar with file path and document symbols
		"@local/winbar.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-mini/mini.icons" },
		opts = {
			excluded_fn = function()
				-- INFO: Exclude those non-exsited files
				return not vim.uv.fs_stat(vim.fn.expand("%:p"))
			end,
			excluded_filetypes = {
				"git",
				"help",
				"noice",
				"terminal",
				"oil",
			},
		},
	},
}
