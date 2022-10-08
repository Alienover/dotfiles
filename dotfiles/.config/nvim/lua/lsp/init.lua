local utils = require("utils")
local constants = require("utils.constants")

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

local marks = require("lsp-marks")

local o, nmap = utils.o, utils.nmap

local icons = constants.icons

local installed_lsp = {
  ["null-ls"] = {
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
  sumneko_lua = {
    format = false,
    filename = "sumneko-lsp",
  },
}

local init_mason = function()
  local config = {
    ensure_installed = {},
  }

  for key, _ in pairs(installed_lsp) do
    table.insert(config.ensure_installed, key)
  end

  mason_lspconfig.setup(config)
end

-- Keymaps for LSP interfaces
local lsp_keymaps = function(_, bufnr)
  local keymap_opts = { noremap = true, silent = true, buffer = bufnr }

  nmap("go", marks.go_back, keymap_opts)
  nmap("gd", marks.go_def, keymap_opts)
  nmap("gD", vim.lsp.buf.declaration, keymap_opts)
  nmap("gi", vim.lsp.buf.implementation, keymap_opts)
  nmap("gr", vim.lsp.buf.references, keymap_opts)
end

-- Formatting config
local lsp_formatting = function(client, bufnr)
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
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = {
        prefix = " ",
        spacing = 4,
      },
      signs = true,
      underline = true,
      severity_sort = true,
      update_in_insert = false,
    }
  )

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
    local capabilities = require("cmp_nvim_lsp").update_capabilities(
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

local function init_lsp()
  local function load_config(name)
    local config = {}

    if (name or "") ~= "" then
      local config_filename = "lsp/" .. name

      if pcall(function()
        require(config_filename)
      end) then
        config = require(config_filename)
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

init_mason()
init_lsp()
