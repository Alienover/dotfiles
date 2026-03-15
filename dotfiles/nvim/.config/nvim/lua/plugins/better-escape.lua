---@type LazySpec
return {
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		opts = {
			default_mappings = false,
			mappings = {
				-- i for insert
				i = {
					j = {
						-- These can all also be functions
						k = "<Esc>",
						j = "<Esc>",
					},
				},
			},
		},
	},
}
