-- Reference
-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/gitsigns.lua
local utils = require("custom.utils")
local gs = require("gitsigns")

local config = {
	signs = {
		add = { text = "▍" },
		change = { text = "▍" },
		delete = { text = "▸" },
		topdelete = { text = "▾" },
		changedelete = { text = "▍" },
		untracked = { text = "▍" },
	},

	preview_config = {
		border = "rounded",
	},

	on_attach = function(bufnr)
		local make_hunk_navigate = function(key, gs_fn)
			return function()
				if vim.wo.diff then
					return key .. "zz"
				end

				vim.schedule(function()
					gs_fn()
					vim.api.nvim_feedkeys("zz", "n", false)
				end)
				return "<Ignore>"
			end
		end

		local make_opts = function(opts)
			return vim.tbl_extend("force", { buffer = bufnr }, opts or {})
		end

		utils.create_keymaps({
			-- Hunk Navigation
			{
				"n",
				"]c",
				make_hunk_navigate("]c", gs.next_hunk),
				make_opts({ expr = true }),
			},
			{
				"n",
				"[c",
				make_hunk_navigate("[c", gs.prev_hunk),
				make_opts({ expr = true }),
			},

			-- Text Objects
			{ { "o", "x" }, "ih", gs.select_hunk },
		})
	end,
}

gs.setup(config)
