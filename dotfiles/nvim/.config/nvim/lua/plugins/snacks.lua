return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@module 'snacks'
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			bufdelete = { enabled = true },
			gitbrowse = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			picker = {
				ui_select = true,
				layout = { preset = "telescope" },
				formatters = {
					file = {
						filename_first = true,
					},
				},
				layouts = {
					ivy = {
						layout = {
							height = 0.3,
						},
					},
					select = {
						layout = {
							max_width = 80,
						},
					},
				},
				win = {
					input = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },

							-- Preview scorlling
							["<C-f>"] = false,
							["<C-b>"] = false,
							["<C-d>"] = { "preview_scroll_down", mode = { "n", "i" } },
							["<C-u>"] = { "preview_scroll_up", mode = { "n", "i" } },
						},
					},
				},
			},
			statuscolumn = {
				right = { "git", "fold" },
				folds = {
					open = true, -- show open fold icons
					git_hl = true, -- use Git Signs hl for fold icons
				},
			},
			zen = {
				toggles = {
					dim = false,
				},
			},
		},
		keys = {
			-- Buffers
			{
				"<space>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "[D]elete",
			},

			-- Git
			{
				"<space>go",
				function()
					Snacks.gitbrowse()
				end,
				desc = "[O]pen in browse",
				mode = { "n", "v" },
			},

			-- Notifier
			{
				"<space><esc>",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Clear all notifications",
			},
			{
				"<space>hn",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Show notifier history",
			},

			-- Zen
			{
				"<space>z",
				function()
					Snacks.zen.zoom()
				end,
				desc = "Toggle Zoom",
			},
			{
				"<space>Z",
				function()
					Snacks.zen()
				end,
				desc = "[Z]en Mode",
			},
		},
	},
}
