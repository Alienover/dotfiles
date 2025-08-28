---@type LazySpec
return {
	{ -- Git Gutter
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {

			signs = {
				add = { text = "▍" },
				change = { text = "▍" },
				delete = { text = " " },
				topdelete = { text = " " },
				changedelete = { text = "▍" },
				untracked = { text = "▍" },
			},

			preview_config = {
				border = "rounded",
			},
		},
		config = function(_, opts)
			local gs = require("gitsigns")

			gs.setup(vim.tbl_extend("force", opts, {
				on_attach = function(bufnr)
					local make_hunk_navigate = function(key, direction)
						return function()
							if vim.wo.diff then
								return key .. "zz"
							end

							gs.nav_hunk(direction)

							return "<Ignore>"
						end
					end

					require("custom.utils").create_keymaps({
					  -- stylua: ignore start
						-- Hunk Navigation
						{ "n", "]c", make_hunk_navigate("]c", "next"), { buffer = bufnr, expr = true } },
						{ "n", "[c", make_hunk_navigate("[c", "prev"), { buffer = bufnr, expr = true } },

						{ "n", "<space>gp", gs.preview_hunk, { buffer = bufnr, desc = "[P]review hunk" } },
						{ "n", "<space>gb", gs.blame_line, { buffer = bufnr, desc = "[B]lame line" } },
						{ "n", "<space>gR", gs.reset_buffer, { buffer = bufnr, desc = "[R]eset buffer" } },

						{ { "n", "v" }, "<space>gs", ":Gitsign stage_hunk<CR>", { buffer = bufnr, desc = "[S]tage hunk" } },
						{ { "n", "v" }, "<space>gr", ":Gitsign reset_hunk<CR>", { buffer = bufnr, desc = "[R]eset hunk" } },

						-- Text Objects
						{ { "o", "x" }, "ih", gs.select_hunk },

						-- Blame
						{ { "n" }, "<space>gB", ":Gitsign blame<CR>", { buffer = bufnr, desc = "[Blame] current buffer" } },
						-- stylua: ignore end
					})
				end,
			}))
		end,
	},

	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gvdiffsplit" },
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
