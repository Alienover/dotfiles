---@type LazySpec
return {
	{
		"max397574/better-escape.nvim",
		-- INFO: on trial against `mini.keymap`'s `map_combo` (see `mini.lua`).
		-- Flip this back to re-enable, and drop the combos there.
		enabled = false,
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
