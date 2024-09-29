return {
	{ -- Completions
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Sources
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"ray-x/cmp-treesitter",
			{ "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
		},
		config = function()
			require("config.cmp-config")
		end,
	},
}
