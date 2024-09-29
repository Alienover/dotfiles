local utils = require("custom.utils")
local icons = require("custom.icons")
local constants = require("custom.constants")

local lspconfig = require("lspconfig")

local nmap = utils.nmap

local external_type = constants.external_type
local ensure_externals = constants.ensure_externals

-- Keymaps for LSP interfaces
local lsp_keymaps = function(_, bufnr)
	local function map(keys, fnc, desc)
		local opts = { buffer = bufnr }
		if desc then
			opts.desc = "LSP: " .. desc
		end

		nmap(keys, fnc, opts)
	end

	map("go", "<C-o>zz", "[G]o [O]riginal")
	map("gd", vim.lsp.buf.definition, "[G]o [D]efinition")
	map("gD", vim.lsp.buf.declaration, "[G]o [D]eclaration")
	map("gi", vim.lsp.buf.implementation, "[G]o [I]mplementation")
	map("gr", vim.lsp.buf.references, "[G]o [R]eferences")
	map("]d", function()
		vim.diagnostic.goto_next({
			float = {
				border = "rounded",
			},
		})
	end, "Next [D]iagnostic ")
	map("[d]", function()
		vim.diagnostic.goto_prev({
			float = {
				border = "rounded",
			},
		})
	end, "Previous [D]iagnostic")
end

-- Custom on_attach handler
local on_attach = function(client, bufnr)
	lsp_keymaps(client, bufnr)
end

---@param filename string
---@return table
local load_config = function(filename)
	local config = {}

	-- INFO: Load the config file if given
	if (filename or "") ~= "" then
		local success, module = pcall(require, filename)
		if success then
			config = module
		end
	end

	-- INFO: Capabilities config for nvim-cmp
	local custom_capabilities = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end

	local DEFAULT_CONFIG = {
		-- INFO: disable on diff view by default
		autostart = vim.o.diff == false,

		on_attach = on_attach,
		capabilities = custom_capabilities(),
		flags = {
			debounce_text_changes = 150,
		},
	}

	return vim.tbl_deep_extend("force", DEFAULT_CONFIG, config)
end

-- Re-write lsp handlers
local rewrite_lsp_handlers = function()
	-- Automatically update diagnostics
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = {
			prefix = " ",
			spacing = 4,
		},
		signs = true,
		underline = true,
		severity_sort = true,
		update_in_insert = false,
	})

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

-- Re-write lsp diagnostic icons
local rewrite_lsp_icons = function()
	local signs = {
		Error = icons.get("extended", "error"),
		Warn = icons.get("extended", "warn"),
		Hint = icons.get("extended", "hint"),
		Info = icons.get("extended", "info"),
	}

	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
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
	-- Setup the lsp for the one installed manually
	for server, opts in pairs(ensure_externals) do
		local is_lsp = opts.external_type == external_type.lsp

		if is_lsp == true then
			local config = load_config(opts.config_file)

			lspconfig[server].setup(config)
		end
	end

	rewrite_lsp_handlers()
	rewrite_lsp_icons()
	rewrite_lsp_cmds()
end

setup_lsp()
