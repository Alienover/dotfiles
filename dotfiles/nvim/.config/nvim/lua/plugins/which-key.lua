---@type LazySpec
return {
	{
		"folke/which-key.nvim",
		keys = { "<space>" },
		event = { "VeryLazy" },
		--- @type wk.Opts
		opts = {
			---@type false | "classic" | "modern" | "helix"
			preset = "helix",

			---@type wk.Win.opts
			win = { border = "rounded" },
			layout = {
				width = { min = 20, max = 50 }, -- min and max width of the columns
				spacing = 5, -- spacing between columns
			},
			triggers = { { "<space>" }, { "<leader>" } },
			show_help = false,
			show_keys = false,
		},
		---@param opts wk.Opts
		config = function(_, opts)
			local wk = require("which-key")
			local constants = require("custom.constants")

			wk.setup(opts)

			wk.add({
				--- @module 'snacks'

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
				{ "<space>oz", "<CMD>e " .. constants.files.zsh .. "<CR>", desc = ".zshrc" },
				{ "<space>ot", "<CMD>e " .. constants.files.tmux .. "<CR>", desc = ".tmux.conf" },
				{ "<space>on", "<CMD>e " .. constants.files.nvim .. "<CR>", desc = "init.lua" },
				{ "<space>oA", "<CMD>e " .. constants.files.alacritty .. "<CR>", desc = "alacritty.toml" },
				{ "<space>oa", "<CMD>e " .. constants.files.aerospace .. "<CR>", desc = "aerospace.toml" },
			})
		end,
	},
}
