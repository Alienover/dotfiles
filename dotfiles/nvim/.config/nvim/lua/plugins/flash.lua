---@type LazySpec
return {
	{ -- Navigate with labels
		"folke/flash.nvim",
		---@type Flash.Config
		opts = {
			prompt = {
				enabled = false,
			},
			modes = {
				char = {
					jump_labels = true,
				},
				search = {
					enabled = false,
				},
			},
		},

    -- stylua: ignore
		keys = {
			{ "<c-f>", function() require("flash").toggle() end, mode = "c", desc = "Toggle Flash Search" },
			{ "<c-s>", function() require("flash").jump() end, mode = "n", desc = "Flash" },
			{ "S", function() require("flash").treesitter() end, mode = { "o", "x" }, desc = "Flash Treesitter" },
			{ "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Treesitter Search" },
			"f",
			"F",
		},
	},
}
