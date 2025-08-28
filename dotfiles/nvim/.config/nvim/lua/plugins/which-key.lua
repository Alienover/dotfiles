---@type LazySpec
return {
	{
		"folke/which-key.nvim",
		keys = { "<space>" },
		event = { "VeryLazy" },
		config = function()
			require("config.which-key-config")
		end,
	},
}
