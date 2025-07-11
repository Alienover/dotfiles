return {
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
