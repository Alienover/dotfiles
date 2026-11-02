local nav = require("util.rex_navigation")

---@type LazySpec
return {
	{ -- Rex Navigation (local, see lua/util/rex_navigation.lua)
		"nvim-rex-navigation",
		virtual = true,
		cond = nav.enabled(),
		keys = {
			{
				"<C-h>",
				function()
					nav.navigate("h")
				end,
				desc = "Navigate left (nvim/rex)",
			},
			{
				"<C-j>",
				function()
					nav.navigate("j")
				end,
				desc = "Navigate down (nvim/rex)",
			},
			{
				"<C-k>",
				function()
					nav.navigate("k")
				end,
				desc = "Navigate up (nvim/rex)",
			},
			{
				"<C-l>",
				function()
					nav.navigate("l")
				end,
				desc = "Navigate right (nvim/rex)",
			},
		},
	},
}
