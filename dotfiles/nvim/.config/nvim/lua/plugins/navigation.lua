local nav = require("util.mux_navigation")

local left = "<C-h>"
local down = "<C-j>"
local up = "<C-k>"
local right = "<C-l>"

---@type LazySpec
return {
	{ -- Tmux Navigation
		"alexghergh/nvim-tmux-navigation",
		cond = vim.env.TMUX ~= nil,
		keys = { left, down, up, right },
		opts = {
			disable_when_zoomed = true, -- defaults to false
			keybindings = {
				left = left,
				down = down,
				up = up,
				right = right,
				last_active = nil,
				next = nil,
			},
		},
	},
	{ -- Rex/Herdr Navigation (local, see lua/util/mux_navigation.lua)
		"nvim-mux-navigation",
		virtual = true,
		cond = nav.enabled(),
		init = nav.advertise,
		keys = {
			{
				left,
				function()
					nav.navigate("h")
				end,
				desc = "Navigate left (nvim/rex/herdr)",
			},
			{
				down,
				function()
					nav.navigate("j")
				end,
				desc = "Navigate down (nvim/rex/herdr)",
			},
			{
				up,
				function()
					nav.navigate("k")
				end,
				desc = "Navigate up (nvim/rex/herdr)",
			},
			{
				right,
				function()
					nav.navigate("l")
				end,
				desc = "Navigate right (nvim/rex/herdr)",
			},
		},
	},
}
