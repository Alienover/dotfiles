---@module 'snacks'
---@type LazySpec
return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = { "mason-org/mason.nvim" },
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

			-- Re-write lsp handlers so the built-in `grn`, `grr` and `gO` keep working
			-- but open the Snacks pickers.
			--
			-- INFO: the default mappings call these with no arguments, so anything
			-- passing arguments is a programmatic caller and must reach the original.
			-- `:ObsidianRename` passes a new name and `:ObsidianTOC` passes an
			-- `on_list` handler; both break if their arguments are dropped.
			local buf = vim.lsp.buf

			local references = buf.references
			---@diagnostic disable-next-line: duplicate-set-field
			buf.references = function(context, opts)
				if context == nil and opts == nil then
					return Snacks.picker.lsp_references()
				end

				return references(context, opts)
			end

			local document_symbol = buf.document_symbol
			---@diagnostic disable-next-line: duplicate-set-field
			buf.document_symbol = function(opts)
				if opts == nil then
					return Snacks.picker.lsp_symbols({ layout = { preset = "vscode" } })
				end

				return document_symbol(opts)
			end

			local rename = buf.rename
			---@diagnostic disable-next-line: duplicate-set-field
			buf.rename = function(new_name, opts)
				if new_name == nil and opts == nil then
					return vim.fn.feedkeys(":IncRename " .. vim.fn.expand("<cword>"))
				end

				return rename(new_name, opts)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("custom/lsp", { clear = true }),
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
