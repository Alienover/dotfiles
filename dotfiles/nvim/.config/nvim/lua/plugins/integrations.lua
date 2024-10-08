return {
	{ -- Client for HTTP requests
		"rest-nvim/rest.nvim",
		ft = { "http" },
		config = function()
			require("config.rest-config")
		end,
	},

	{ -- Zen
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
				gitsigns = { enabled = false }, -- disables git signs
				tmux = { enabled = false }, -- disables the tmux statusline
				kitty = { enabled = false, font = "+2" },
			},
		},
	},

	{ -- Tmux Navigation
		"alexghergh/nvim-tmux-navigation",
		keys = {
			{ "<C-w>h", "<CMD>NvimTmuxNavigateLeft<CR>", desc = "Focus Left Pane" },
			{ "<C-w>l", "<CMD>NvimTmuxNavigateRight<CR>", desc = "Focus Right Pane" },
			{ "<C-w>j", "<CMD>NvimTmuxNavigateDown<CR>", desc = "Focus Down Pane" },
			{ "<C-w>k", "<CMD>NvimTmuxNavigateUp<CR>", desc = "Focus Up Pane" },
		},
		opts = {
			keybindings = {
				last_active = nil,
				next = nil,
			},
		},
	},
}
