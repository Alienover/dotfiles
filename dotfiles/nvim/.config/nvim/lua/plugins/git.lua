---@type LazySpec
return {
	{ -- Git Gutter
		"lewis6991/gitsigns.nvim",
		event = "User LazyPost",
		opts = {

			signs = {
				add = { text = "▍" },
				change = { text = "▍" },
				delete = { text = " " },
				topdelete = { text = " " },
				changedelete = { text = "▍" },
				untracked = { text = "▍" },
			},
			preview_config = { border = "rounded" },
			on_attach = function(bufnr)
					-- Hunk Navigation
					vim.keymap.set("n", "]c", "<CMD>Gitsigns next_hunk<CR>zz", { buffer = bufnr, desc = "Next Hunk" })
					vim.keymap.set("n", "[c", "<CMD>Gitsigns prev_hunk<CR>zz", { buffer = bufnr, desc = "Prev Hunk" })

					vim.keymap.set("n", "<space>gp", "<CMD>Gitsigns preview_hunk<CR>", { buffer = bufnr, desc = "[P]review hunk" })
					vim.keymap.set("n", "<space>gb", "<CMD>Gitsigns blame_line<CR>", { buffer = bufnr, desc = "[B]lame line" })

					vim.keymap.set({ "n", "v" }, "<space>gs", ":Gitsigns stage_hunk<CR>", { buffer = bufnr, desc = "[S]tage hunk" })
					vim.keymap.set({ "n", "v" }, "<space>gr", ":Gitsigns reset_hunk<CR>", { buffer = bufnr, desc = "[R]eset hunk" })

					-- Text Objects
					vim.keymap.set({ "o", "x" }, "ih", ":Gitsigns select_hunk<CR>", { buffer = bufnr })

					-- Blame
					vim.keymap.set({ "n" }, "<space>gB", ":Gitsign blame<CR>", { buffer = bufnr, desc = "[Blame] current buffer" })
			end,
		},
	},

	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gvdiffsplit", "GBrowse" },
		dependencies = { "tpope/vim-rhubarb", "barrettruth/diffs.nvim" },
		init = function()
			vim.g.diffs = { fugitive = true }
		end,
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("Custom_Fugitive", { clear = true }),
				pattern = "fugitive",
				callback = function(args)
					vim.keymap.set("n", "o", "=", { buffer = args.buf, remap = true })
				end,
			})
		end,
	},
}
