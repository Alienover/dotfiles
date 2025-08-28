---@type LazySpec
return {
	{
		"stevearc/oil.nvim",
		lazy = vim.fn.argc(-1) == 0, -- load oil early when opening a file from the cmdline
		cmd = { "Oil" },
		-- Optional dependencies
		dependencies = { "echasnovski/mini.icons" },
		config = function()
			require("config.oil-config")
		end,
	},
}
