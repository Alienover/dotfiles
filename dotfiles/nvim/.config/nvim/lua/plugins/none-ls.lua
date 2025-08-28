---@type LazySpec
return {
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre" },
		priority = 10,
		config = function()
			-- Register the `null-ls` in vim.lsp
			vim.lsp.config("null-ls", {})

			local null_ls = require("null-ls")

			-- Custom ruff command to organize the imports
			local ruff_organize_imports = {
				name = "ruff_organize_imports",
				method = null_ls.methods.FORMATTING,
				filetypes = { "python" },
				generator = null_ls.formatter({
					command = "ruff",
					args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
					to_stdin = true,
				}),
			}

			null_ls.setup({
				sources = {
					ruff_organize_imports,

					null_ls.builtins.formatting.prettier.with({
						prefer_local = "node_modules/.bin",
					}),
					null_ls.builtins.formatting.stylua,

					null_ls.builtins.formatting.erb_format.with({
						extra_args = { "--print-width", "120" },
					}),

					null_ls.builtins.code_actions.gitsigns,
				},
			})

			--- INFO: override the builit-in info window
			vim.api.nvim_del_user_command("NullLsInfo")
			vim.api.nvim_create_user_command("NullLsInfo", function()
				require("null-ls.info").show_window()

				vim.schedule(function()
					local winnr = vim.api.nvim_get_current_win()

					vim.api.nvim_win_set_config(winnr, require("custom.utils").get_float_win_opts({ border = true }))

					vim.api.nvim_set_option_value("winhl", "NullLsInfoBorder:FloatBorder", { win = winnr })
				end)
			end, {})
		end,
	},
}
