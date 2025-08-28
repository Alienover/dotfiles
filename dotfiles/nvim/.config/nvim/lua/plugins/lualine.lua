---@type LazySpec
return {
	{ -- Status Line
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("config.lualine-config")
		end,
	},
}
