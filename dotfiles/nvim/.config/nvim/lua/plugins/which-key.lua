---@type LazySpec
return {
	{
		"folke/which-key.nvim",
		keys = { "<space>" },
		event = { "VeryLazy" },
		opts = {
			---@type false | "classic" | "modern" | "helix"
			preset = false,

			---@type wk.Win.opts
			win = {
				width = vim.o.columns > 200 and 0.4 or 0.6,
				col = 0.5,
				---@type 'none' | 'rounded'
				border = "none",
			},
			layout = {
				width = { min = 20, max = 50 }, -- min and max width of the columns
				spacing = 5, -- spacing between columns
			},
		},
		---@param opts wk.Opts
		config = function(_, opts)
			local wk = require("which-key")
			local constants = require("custom.constants")

			wk.setup(opts)

			local function e(filepath)
				return "<CMD>e " .. filepath .. "<CR>"
			end

			wk.add({
				-- Help
				{ "<space>/", Snacks.picker.lines, desc = "Search" },
				{ "<space>h?", Snacks.picker.help, desc = "Help doc" },
				{ "<space>hc", Snacks.picker.commands, desc = "[C]ommands" },
				{ "<space>hh", Snacks.picker.highlights, desc = "[H]ighlight Groups" },
				{ "<space>hk", Snacks.picker.keymaps, desc = "[K]ey Maps" },
				{ "<space>hlS", "<CMD>Lazy sync<CR>", desc = "[S]ync Plugins" },
				{ "<space>hls", "<CMD>Lazy show<CR>", desc = "[S]how Plugins" },
				{ "<space>hm", "<CMD>Mason<CR>", desc = "[M]ason Manager" },
				{ "<space>hu", Snacks.picker.undo, desc = "[U]ndo tree" },

				-- Open File
				{ "<space>o", group = "Open" },
				{ "<space>oz", e(constants.files.zsh), desc = ".zshrc" },
				{ "<space>ot", e(constants.files.tmux), desc = ".tmux.conf" },
				{ "<space>on", e(constants.files.nvim), desc = "init.lua" },
				{ "<space>oA", e(constants.files.alacritty), desc = "alacritty.toml" },
				{ "<space>oa", e(constants.files.aerospace), desc = "aerospace.toml" },
			})
		end,
	},
}
