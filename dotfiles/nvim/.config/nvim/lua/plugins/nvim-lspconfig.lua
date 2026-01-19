---@type LazySpec
return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local utils = require("custom.utils")
			local icons = require("custom.icons")
			local consts = require("custom.constants")

			-- INFO: Enable pre-defined LSP
			for name in pairs(consts.ensure_externals) do
				vim.lsp.enable(name)
			end

			-- INFO: Disable the log, set it to "debug" when necessary
			vim.lsp.set_log_level("off")

			-- INFO: Configure the diagnostic styling
			vim.diagnostic.config({
				float = {
					severity_sort = true,
					source = "if_many",
					border = "rounded",
				},
				virtual_lines = { current_line = true },
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.get("extended", "error"),
						[vim.diagnostic.severity.WARN] = icons.get("extended", "warn"),
						[vim.diagnostic.severity.INFO] = icons.get("extended", "info"),
						[vim.diagnostic.severity.HINT] = icons.get("extended", "hint"),
					},
				},
				-- virtual_text = {
				-- 	prefix = "  ",
				-- 	spacing = 4,
				-- },
			})

			-- INFO: Re-write lsp handlers
			vim.lsp.buf.references = Snacks.picker.lsp_references

			---@diagnostic disable-next-line: duplicate-set-field
			vim.lsp.buf.document_symbol = function()
				Snacks.picker.lsp_symbols({ layout = { preset = "vscode" } })
			end

			---@diagnostic disable-next-line: duplicate-set-field
			vim.lsp.buf.rename = function()
				vim.fn.feedkeys(":IncRename " .. vim.fn.expand("<cword>"))
			end

			-- INFO: Re-write lsp-config built-in functions
			local window = require("lspconfig.ui.windows")
			local og_percentage_range_window = window.percentage_range_window

			-- INFO: Overwrite the function `percentage_range_window` from `nvim-lspconfig`
			-- to create float window with customized config
			---@diagnostic disable-next-line: duplicate-set-field
			window.percentage_range_window = function(...)
				local win_info = og_percentage_range_window(...)

				vim.api.nvim_win_set_config(win_info.win_id, utils.get_float_win_opts({ border = true }))

				return win_info
			end

			vim.api.nvim_create_autocmd("LSPAttach", {
				group = vim.api.nvim_create_augroup("SetupLSP", { clear = true }),
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

					-- Disable LSP formatting, use `conform.nvim` to manage the auto-formatting
					client.server_capabilities.documentFormattingProvider = false

					-- Keymaps for LSP interfaces
					vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, { buffer = args.buf })
					vim.keymap.set("n", "go", "<C-o>zz", { buffer = args.buf })
				end,
			})
		end,
	},
}
