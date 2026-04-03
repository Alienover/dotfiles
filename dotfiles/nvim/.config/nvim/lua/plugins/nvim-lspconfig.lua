---@module 'snacks'
---@type LazySpec
return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		init = function()
			vim.g.lsp_eslint_auto_format = true
		end,
		config = function()
			local icons = require("util.icons")
			local consts = require("util.constants")

			-- Disable the log, set it to "debug" when necessary
			vim.lsp.log.set_level(vim.log.levels.OFF)

			-- Extend neovim's client capabilities with the completion ones.
			vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities(nil, true) })

			-- Enable pre-defined LSP
			local servers = vim.iter(vim.tbl_keys(consts.ensure_externals))
				:filter(function(key)
					return consts.ensure_externals[key].external_type == consts.external_type.lsp
				end)
				:totable()
			vim.lsp.enable(servers)

			-- Configure the diagnostic styling
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

			-- Re-write lsp handlers
			vim.lsp.buf.references = Snacks.picker.lsp_references

			---@diagnostic disable-next-line: duplicate-set-field
			vim.lsp.buf.document_symbol = function()
				Snacks.picker.lsp_symbols({ layout = { preset = "vscode" } })
			end

			---@diagnostic disable-next-line: duplicate-set-field
			vim.lsp.buf.rename = function()
				vim.fn.feedkeys(":IncRename " .. vim.fn.expand("<cword>"))
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("SetupLSP", { clear = true }),
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

					-- Disable LSP formatting, use `conform.nvim` to manage the auto-formatting
					client.server_capabilities.documentFormattingProvider = vim.g["lsp_" .. client.name .. "_auto_format"]
						or false

					-- Keymaps for LSP interfaces
					vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, { buffer = args.buf })
					vim.keymap.set("n", "go", "<C-o>zz", { buffer = args.buf })
				end,
			})
		end,
	},
}
