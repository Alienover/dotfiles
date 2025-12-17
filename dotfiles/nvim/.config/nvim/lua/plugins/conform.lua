---@type LazySpec
return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo", "Format" },
		---@module 'conform'
		---@type conform.setupOpts
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format", "ruff_organize_imports" },
				json = { "prettier" },
				jsonc = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				-- Use the "*" filetype to run formatters on all filetypes.
				["*"] = { "trim_whitespace" },
			},
			-- Set this to change the default values when calling conform.format()
			-- This will also affect the default values for format_on_save/format_after_save
			default_format_opts = { lsp_format = "fallback" },
			-- If this is set, Conform will run the formatter on save.
			-- It will pass the table to conform.format().
			-- This can also be a function that returns the table.
			format_on_save = { timeout_ms = 1000 },

			formatters = {
				ruff_format = {
					append_args = { "--line-length", "100" },
				},
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)

			--- INFO: override the builit-in info window
			vim.api.nvim_del_user_command("ConformInfo")
			vim.api.nvim_create_user_command("ConformInfo", function()
				require("conform.health").show_window()

				vim.schedule(function()
					vim.api.nvim_win_set_config(
						vim.api.nvim_get_current_win(),
						require("custom.utils").get_float_win_opts({ border = true })
					)
				end)
			end, {})

			-- Command to run async formatting
			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_format = "fallback", range = range })
			end, { range = true })
		end,
	},
}
