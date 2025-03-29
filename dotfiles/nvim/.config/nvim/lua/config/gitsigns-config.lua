-- Reference
-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/gitsigns.lua
local utils = require("custom.utils")
local gs = require("gitsigns")

local config = {
	signs = {
		add = { text = "▍" },
		change = { text = "▍" },
		delete = { text = " " },
		topdelete = { text = " " },
		changedelete = { text = "▍" },
		untracked = { text = "▍" },
	},

	preview_config = {
		border = "rounded",
	},

	on_attach = function(bufnr)
		local make_hunk_navigate = function(key, direction)
			return function()
				if vim.wo.diff then
					return key .. "zz"
				end

				gs.nav_hunk(direction)

				return "<Ignore>"
			end
		end

		utils.create_keymaps({
			-- Hunk Navigation
			{
				"n",
				"]c",
				make_hunk_navigate("]c", "next"),
				{ buffer = bufnr, expr = true },
			},
			{
				"n",
				"[c",
				make_hunk_navigate("[c", "prev"),
				{ buffer = bufnr, expr = true },
			},

			-- Text Objects
			{ { "o", "x" }, "ih", gs.select_hunk },
		})
	end,
}

gs.setup(config)
