local utils = require("utils")
local constants = require("utils.constants")

local lspconfig = require("lspconfig")
local lspinstaller = require("nvim-lsp-installer")

local marks = require("config/marks-config")

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
  html = {
    format = false,
  },
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

local on_attach = function(client)
  marks.init()

  -- Keymap
  local keymap_opts = { noremap = true, silent = true }

  nmap("go", marks.go_back, keymap_opts)
  nmap("gd", marks.go_def, keymap_opts)
  nmap("gD", vim.lsp.buf.declaration, keymap_opts)
  nmap("gi", vim.lsp.buf.implementation, keymap_opts)
  nmap("gr", "<cmd>Telescope lsp_references<CR>", keymap_opts)

  local lsp_opts = installed_lsp[client.name]

  local format = true
  -- Set the document formatting to false only when the format option is false
  if lsp_opts ~= nil and lsp_opts.format == false then
    format = false
  end

  if not format then
    client.resolved_capabilities.document_formatting = false
  end

  if client.resolved_capabilities.document_formatting then
    local formatGroup = vim.api.nvim_create_augroup("Format", { clear = true })

    vim.api.nvim_create_autocmd("BufWritePre", {
      desc = "Format the buffer on save",
      buffer = 0,
      group = formatGroup,
      callback = function()
        vim.lsp.buf.formatting_sync({}, 2 * 1000)
      end,
    })
  end

  -- Alias
  vim.api.nvim_create_user_command("LspFormat", function()
    vim.lsp.buf.formatting({})
  end, {})
end

local lsp_highlight_document = function(client, _)
  local status_ok, illuminate = pcall(require, "illuminate")
  if not status_ok then
    return
  end

  illuminate.on_attach(client)
end

  lsp_highlight_document(client, bufnr)
local custom_capabilities = function()
  local capabilities = require("cmp_nvim_lsp").update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )
  return capabilities
end

local function init_lsp()
  local DEFAULT_CONFIG = {
    autostart = o.diff == false,
    on_attach = on_attach,
    capabilities = custom_capabilities(),
    flags = {
      debounce_text_changes = 150,
    },
  }

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

    return vim.tbl_deep_extend("force", DEFAULT_CONFIG, config)
  end

  -- Setup the lsp for the one installed manually
  for server, opts in pairs(installed_lsp) do
    local config = load_config(opts.filename)

    local existed, requested_server = lspinstaller.get_server(server)

    if existed then
      requested_server:on_ready(function()
        requested_server:setup(config)
      end)

      if not requested_server:is_installed() then
        -- Queue the requested_server to be installed
        requested_server:install()
      end
    else
      if opts.setup ~= nil then
        opts.setup(config)
      else
        lspconfig[server].setup(config)
      end
    end
  end
end

init_lsp()

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
