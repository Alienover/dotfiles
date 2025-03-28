return {
	{
		"Alienover/blame.nvim",
		cmd = { "Git", "GitBlame" },
		config = function()
			require("config.git-config")
		end,
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
