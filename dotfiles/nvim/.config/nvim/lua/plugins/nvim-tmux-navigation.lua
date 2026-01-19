---@type LazySpec
return {
	{ -- Tmux Navigation
		"alexghergh/nvim-tmux-navigation",
		keys = {
			"<C-h>",
			"<C-j>",
			"<C-k>",
			"<C-l>",
		},
		opts = {
			disable_when_zoomed = true, -- defaults to false
			keybindings = {
				left = "<C-h>",
				down = "<C-j>",
				up = "<C-k>",
				right = "<C-l>",
				last_active = nil,
				next = nil,
			},
		},
	},
}
