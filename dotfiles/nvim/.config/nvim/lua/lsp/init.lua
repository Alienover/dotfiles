local utils = require("custom.utils")
local icons = require("custom.icons")
local constants = require("custom.constants")
local mason_pkgs = require("custom.mason_pkgs")

local ensure_externals = constants.ensure_externals

---@module 'snacks'

-- Keymaps for LSP interfaces
local setup_keymaps = function(_, bufnr)
	utils.nmap("gd", Snacks.picker.lsp_definitions, { buffer = bufnr })
	utils.nmap("go", "<C-o>zz", { buffer = bufnr })
end

---@param external External
---@return table
local load_config = function(external)
	local filename = external.config_file

	local config = {}

	-- INFO: Load the config file if given
	if (filename or "") ~= "" then
		local success, module = pcall(require, filename)
		if success then
			config = vim.tbl_extend("force", module, module.settings and {
				init_options = {
					settings = module.settings,
				},
			} or {})
		end
	end

	-- Custom on_attach handler
	local on_attach = function(client, bufnr)
		-- Disable LSP formatting
		if external.formatting == false then
			client.server_capabilities.documentFormattingProvider = false
		end

		setup_keymaps(client, bufnr)
	end

	local DEFAULT_CONFIG = {
		-- INFO: disable on diff view by default
		autostart = vim.o.diff == false,
		on_attach = on_attach,
		flags = { debounce_text_changes = 150 },
	}

	return vim.tbl_deep_extend("force", DEFAULT_CONFIG, config)
end

-- Re-write lsp handlers
local rewrite_lsp_handlers = function()
	vim.lsp.buf.references = Snacks.picker.lsp_references

	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.buf.document_symbol = function()
		Snacks.picker.lsp_symbols({ layout = { preset = "vscode" } })
	end

	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.buf.rename = function()
		vim.fn.feedkeys(":IncRename " .. vim.fn.expand("<cword>"))
	end
end

-- Configure the diagnostic styling
local setup_diagnostic = function()
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
end

-- Re-write lsp-config built-in functions
local rewrite_lsp_cmds = function()
	local window = require("lspconfig.ui.windows")
	local og_percentage_range_window = window.percentage_range_window

	-- INFO: overwrite the function `percentage_range_window` from `nvim-lspconfig`
	-- to create float window with customized config
	---@diagnostic disable-next-line: duplicate-set-field
	window.percentage_range_window = function(...)
		local win_info = og_percentage_range_window(...)

		vim.api.nvim_win_set_config(win_info.win_id, utils.get_float_win_opts({ border = true }))

		return win_info
	end
end

local function setup_lsp()
	-- Disable the log, set it to "debug" when necessary
	vim.lsp.set_log_level("off")

	setup_diagnostic()

	local enabled_pkgs = mason_pkgs:read()

	-- Setup the lsp for the one installed manually
	for server, opts in pairs(ensure_externals) do
		if vim.tbl_contains(enabled_pkgs, opts.mason) then
			local config = load_config(opts)

			vim.lsp.config(server, config)

			vim.lsp.enable(server)
		end
	end

	rewrite_lsp_handlers()
	rewrite_lsp_cmds()
end

setup_lsp()
