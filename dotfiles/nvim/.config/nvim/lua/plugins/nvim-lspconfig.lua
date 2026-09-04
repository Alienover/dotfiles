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

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("custom/lsp", { clear = true }),
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

					-- Disable LSP formatting, use `conform.nvim` to manage the auto-formatting
					client.server_capabilities.documentFormattingProvider = vim.g["lsp_" .. client.name .. "_auto_format"]
						or false

					-- Keymaps for LSP interfaces
					--
					-- INFO: `grr`, `gO` and `grn` are Neovim's default LSP mappings.
					-- Overriding them buffer-locally shadows the defaults without
					-- patching `vim.lsp.buf.*`, which would also change behaviour for
					-- programmatic callers (`:ObsidianRename` and `:ObsidianTOC` both
					-- call those functions with arguments).
					vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, { buffer = args.buf })
					vim.keymap.set("n", "go", "<C-o>zz", { buffer = args.buf })
					vim.keymap.set("n", "grr", Snacks.picker.lsp_references, { buffer = args.buf })

					vim.keymap.set("n", "gO", function()
						Snacks.picker.lsp_symbols({ layout = { preset = "vscode" } })
					end, { buffer = args.buf })

					vim.keymap.set("n", "grn", function()
						return ":IncRename " .. vim.fn.expand("<cword>")
					end, { buffer = args.buf, expr = true })
				end,
			})
		end,
	},
}
