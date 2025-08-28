---@module 'lazy'
---@type LazySpec
return {
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
