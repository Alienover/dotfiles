---@module 'lazy'
---@type LazySpec
return {
	{ -- Tmux Navigation
		"alexghergh/nvim-tmux-navigation",
		cond = function()
			return vim.fn.getenv("TMUX") ~= vim.NIL
		end,
		keys = {
			{ "<C-w>h", "<CMD>NvimTmuxNavigateLeft<CR>", mode = { "n", "t" }, desc = "Focus Left Pane" },
			{ "<C-w>l", "<CMD>NvimTmuxNavigateRight<CR>", mode = { "n", "t" }, desc = "Focus Right Pane" },
			{ "<C-w>j", "<CMD>NvimTmuxNavigateDown<CR>", mode = { "n", "t" }, desc = "Focus Down Pane" },
			{ "<C-w>k", "<CMD>NvimTmuxNavigateUp<CR>", mode = { "n", "t" }, desc = "Focus Up Pane" },
		},
		opts = {
			keybindings = {
				last_active = nil,
				next = nil,
			},
		},
	},
}
