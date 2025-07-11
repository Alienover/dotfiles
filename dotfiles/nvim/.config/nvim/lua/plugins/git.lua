return {
	{
		"Alienover/blame.nvim",
		cmd = { "BlameToggle" },
		keys = {
			{ "<space>gB", "<cmd>BlameToggle<CR>", desc = "[B]lame " },
		},
		opts = {
			date_format = "%Y-%m-%d %H:%M",
		},
	},
	{ -- Git Gutter
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("config.gitsigns-config")
		end,
	},

	{
		"tpope/vim-fugitive",
		cmd = { "Git" },
		config = function()
			local group = vim.api.nvim_create_augroup("Custom_Fugitive", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = "fugitive",
				callback = function(args)
					local opts = { buffer = args.buf, remap = true }

					vim.keymap.set("n", "o", "=", opts)
				end,
			})
		end,
	},
}
