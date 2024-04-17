local utils = require("utils")
local constants = require("utils.constants")
local nightly_features = require("utils.features")

local lspconfig = require("lspconfig")

local marks = require("lsp-marks")

local o, nmap = utils.o, utils.nmap

local icons = constants.icons
local external_types = constants.external_types
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

  map("go", marks.go_back, "[G]o [O]riginal")
  map("gd", marks.go_def, "[G]o [D]efinition")
  map("gD", vim.lsp.buf.declaration, "[G]o [D]eclaration")
  map("gi", vim.lsp.buf.implementation, "[G]o [I]mplementation")
  map("gr", vim.lsp.buf.references, "[G]o [R]eferences")
end

-- Formatting config
local lsp_formatting = function(client, _)
  -- Disable the LSP format by default. Manage the formatter in "config.conform-config" instead
  client.server_capabilities.documentFormattingProvider = false
end

-- Custom on_attach handler
local on_attach = function(client, bufnr)
  lsp_keymaps(client, bufnr)
  lsp_formatting(client, bufnr)

  if nightly_features.inlay_hint then
    if client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(bufnr, true)
    end
  end
end

-- Re-write lsp handlers
local rewrite_lsp_handlers = function()
  -- Automatically update diagnostics
  vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = {
        prefix = " ",
        spacing = 4,
      },
      signs = true,
      underline = true,
      severity_sort = true,
      update_in_insert = false,
    })

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
    Error = icons.ERROR,
    Warn = icons.WARN,
    Hint = icons.HINT,
    Info = icons.INFOR,
  }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
end

local rewrite_lsp_cmds = function()
  local window = require("lspconfig.ui.windows")
  local og_percentage_range_window = window.percentage_range_window

  -- INFO: overwrite the function `percentage_range_window` from `nvim-lspconfig`
  -- to create float window with customized config
  ---@diagnostic disable-next-line: duplicate-set-field
  window.percentage_range_window = function(col_range, row_range, options)
    local win_info = og_percentage_range_window(col_range, row_range, options)

    vim.api.nvim_win_set_config(
      win_info.win_id,
      utils.get_float_win_opts({ border = true })
    )

    return win_info
  end
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
    local capabilities = require("cmp_nvim_lsp").default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return capabilities
  end

  local DEFAULT_CONFIG = {
    -- INFO: disable on diff view by default
    autostart = o.diff == false,

    on_attach = on_attach,
    capabilities = custom_capabilities(),
    flags = {
      debounce_text_changes = 150,
    },
  }

  return vim.tbl_deep_extend("force", DEFAULT_CONFIG, config)
end

local function setup_lsp()
  -- Setup the lsp for the one installed manually
  for server, opts in pairs(ensure_externals) do
    local is_lsp = opts[external_types.lsp] or false

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
