local utils = require("custom.utils")
local icons = require("custom.icons")
local constants = require("custom.constants")

local nmap = utils.nmap

local external_type = constants.external_type
local ensure_externals = constants.ensure_externals

-- Keymaps for LSP interfaces
local setup_keymaps = function(_, bufnr)
	local function map(keys, fnc, desc)
		local opts = { buffer = bufnr, remap = true, noremap = false }
		if desc then
			opts.desc = "LSP: " .. desc
		end

		nmap(keys, fnc, opts)
	end

	map("go", "<C-o>zz", "[G]o [O]riginal")
	map("gd", vim.lsp.buf.definition, "[G]o [D]efinition")
	map("gD", vim.lsp.buf.declaration, "[G]o [D]eclaration")
	map("gi", vim.lsp.buf.implementation, "[G]o [I]mplementation")
	map("grr", Snacks.picker.lsp_references, "[G]o [R]eferences")
	map("]d", function()
		vim.diagnostic.jump({ count = 1 })
	end, "Next [D]iagnostic ")
	map("[d", function()
		vim.diagnostic.jump({ count = -1 })
	end, "Previous [D]iagnostic")
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
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.handlers["textDocument/definition"] = function(...)
		local status_ok, ts = pcall(require, "telescope.builtin")
		if not status_ok then
			return
		end

		return ts.lsp_definitions(...)
	end

	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.handlers["textDocument/references"] = function()
		local status_ok, ts = pcall(require, "telescope.builtin")
		if not status_ok then
			return
		end

		return ts.lsp_references({
			bufnr = vim.api.nvim_get_current_buf(),
			winnr = vim.api.nvim_get_current_win(),
		})
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

	-- Setup the lsp for the one installed manually
	for server, opts in pairs(ensure_externals) do
		local is_lsp = opts.external_type == external_type.lsp

		if is_lsp == true then
			local config = load_config(opts)

			vim.lsp.config(server, config)

			vim.lsp.enable(server)
		end
	end

	rewrite_lsp_handlers()
	rewrite_lsp_cmds()
end

setup_lsp()
