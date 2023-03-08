local utils = require("utils")
local constants = require("utils.constants")

local lspconfig = require("lspconfig")

local marks = require("lsp-marks")

local o, nmap = utils.o, utils.nmap

local icons = constants.icons

local excluded_filetypes = {
  "norg",
}

local installed_lsp = {
  ["null-ls"] = {
    external = true,
    filename = "null-lsp",
    setup = function(config)
      config:setup({
        on_attach = config.on_attach,
      })
    end,
  },
  html = { format = false },
  cssls = {},
  vimls = {},
  bashls = {},
  pyright = {},
  tailwindcss = {},
  flow = {
    external = true,
    filename = "flow-lsp",
  },
  jsonls = {
    format = false,
    filename = "json-lsp",
  },
  tsserver = {
    format = false,
    filename = "ts-lsp",
  },
  -- NOTE: `sudo` required
  gopls = {
    filename = "go-lsp",
  },
  ["lua_ls"] = {
    format = false,
    filename = "lua-lsp",
  },
}

local setup_mason = function()
  local ensure_installed = {}

  for key, server in pairs(installed_lsp) do
    if not server.external then
      table.insert(ensure_installed, key)
    end
  end

  require("config.mason-config").setup(ensure_installed)
end

-- Keymaps for LSP interfaces
local lsp_keymaps = function(_, bufnr)
  local function map(keys, fnc, desc)
    local opts = { noremap = true, silent = true, buffer = bufnr }
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
local lsp_formatting = function(client, bufnr)
  local curr_filetype = vim.bo.filetype
  for _, excluded in ipairs(excluded_filetypes) do
    -- Don't setup the lsp formatting for the exlucded filetypes
    if curr_filetype == excluded then
      return
    end
  end

  local lsp_opts = installed_lsp[client.name]

  -- Set the document formatting to false only when the format option is false
  if lsp_opts ~= nil and lsp_opts.format == false then
    client.server_capabilities.documentFormattingProvider = false
  else
    local formatGroup = vim.api.nvim_create_augroup("Format", { clear = true })

    vim.api.nvim_create_autocmd("BufWritePre", {
      desc = "Format the buffer on save",

      buffer = bufnr,
      group = formatGroup,
      callback = function()
        vim.lsp.buf.format({ sync = true, timeout_ms = 2 * 1000 })
      end,
    })
  end

  -- Alias
  vim.api.nvim_create_user_command("LspFormat", function()
    vim.lsp.buf.format()
  end, {})
end

local lsp_highlight_document = function(client, _)
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end

  illuminate.on_attach(client)
end

-- Custom on_attach handler
local on_attach = function(client, bufnr)
  lsp_keymaps(client, bufnr)
  lsp_formatting(client, bufnr)
  lsp_highlight_document(client, bufnr)
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

local extend_config = function(config)
  local custom_capabilities = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
    return capabilities
  end

  local DEFAULT_CONFIG = {
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
  local function load_config(name)
    local config = {}

    if (name or "") ~= "" then
      local config_filename = "lsp." .. name

      local success, module = pcall(require, config_filename)
      if success then
        config = module
      end
    end

    return extend_config(config)
  end

  -- Setup the lsp for the one installed manually
  for server, opts in pairs(installed_lsp) do
    local config = load_config(opts.filename)

    if opts.setup ~= nil then
      opts.setup(config)
    else
      lspconfig[server].setup(config)
    end
  end

  rewrite_lsp_handlers()
  rewrite_lsp_icons()
end

setup_mason()
setup_lsp()
