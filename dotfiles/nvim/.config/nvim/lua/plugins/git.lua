return {
	{
		"Alienover/blame.nvim",
		cmd = { "BlameToggle" },
		keys = {
			{ "<space>gB", "<cmd>BlameToggle<CR>", desc = "[B]lame " },
		},
		opts = {
			date_format = "%Y-%m-%d %H:%M",
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewFileHistory",
		},
		config = function()
			require("config.diffview-config")
		end,
	},

	{ -- Git Gutter
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("config.gitsigns-config")
		end,
	},
}
