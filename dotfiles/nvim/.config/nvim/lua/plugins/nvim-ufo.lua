return {
	{
		"kevinhwang91/nvim-ufo",
		event = { "BufReadPost" },
		dependencies = "kevinhwang91/promise-async",
		config = function()
			require("config.ufo-config")
		end,
	},
}
