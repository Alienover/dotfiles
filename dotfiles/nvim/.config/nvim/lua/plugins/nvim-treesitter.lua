---@type LazySpec
return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		event = { "VeryLazy" },
		build = ":TSUpdate",
		-- TODO: switch to `main` branch when it's ready
		branch = "master",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-refactor",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("config.treesitter-config")
		end,
	},
}
