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
			{ "n", "]c", make_hunk_navigate("]c", "next"), { buffer = bufnr, expr = true } },
			{ "n", "[c", make_hunk_navigate("[c", "prev"), { buffer = bufnr, expr = true } },

			{ "n", "<space>gp", gs.preview_hunk, { buffer = bufnr, desc = "[P]review hunk" } },
			{ "n", "<space>gb", gs.blame_line, { buffer = bufnr, desc = "[B]lame line" } },
			{ "n", "<space>gR", gs.reset_buffer, { buffer = bufnr, desc = "[R]eset buffer" } },

			{ { "n", "v" }, "<space>gs", ":Gitsign stage_hunk<CR>", { buffer = bufnr, desc = "[S]tage hunk" } },
			{ { "n", "v" }, "<space>gr", ":Gitsign reset_hunk<CR>", { buffer = bufnr, desc = "[R]eset hunk" } },

			-- Text Objects
			{ { "o", "x" }, "ih", gs.select_hunk },
		})
	end,
}

gs.setup(config)
