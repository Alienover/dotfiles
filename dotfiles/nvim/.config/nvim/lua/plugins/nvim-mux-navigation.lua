local nav = require("util.mux_navigation")

---@type LazySpec
return {
	{ -- Rex/Herdr Navigation (local, see lua/util/mux_navigation.lua)
		"nvim-mux-navigation",
		virtual = true,
		cond = nav.enabled(),
		keys = {
			{
				"<C-h>",
				function()
					nav.navigate("h")
				end,
				desc = "Navigate left (nvim/rex/herdr)",
			},
			{
				"<C-j>",
				function()
					nav.navigate("j")
				end,
				desc = "Navigate down (nvim/rex/herdr)",
			},
			{
				"<C-k>",
				function()
					nav.navigate("k")
				end,
				desc = "Navigate up (nvim/rex/herdr)",
			},
			{
				"<C-l>",
				function()
					nav.navigate("l")
				end,
				desc = "Navigate right (nvim/rex/herdr)",
			},
		},
	},
}
