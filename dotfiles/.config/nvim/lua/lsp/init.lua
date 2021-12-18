local utils = require("utils")
local constants = require("utils.constants")

local lspconfig = require("lspconfig")
local lspinstaller = require("nvim-lsp-installer")

local nmap, cmd = utils.nmap, utils.cmd

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
  -- `npm` required
  html = {},
  cssls = {},
  vimls = {},
  bashls = {},
  pyright = {},
  tailwindcss = {},
  flow = {
    filename = "flow-lsp",
  },
  jsonls = {
    filename = "json-lsp",
  },
  tsserver = {
    filename = "ts-lsp",
  },
  -- `go` required
  gopls = {
    -- NOTE: `sudo` required
    filename = "go-lsp",
  },
  -- `git` required
  sumneko_lua = {
    filename = "sumneko-lsp",
  },
}

local on_attach = function(client)
  -- Keymap
  local keymap_otps = { noremap = true, silent = true }

  nmap("gb", "<C-o>", keymap_otps)
  nmap("gd", "<cmd>Telescope lsp_definitions<CR>zz", keymap_otps)
  nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>zz", keymap_otps)
  nmap("gr", "<cmd>Telescope lsp_references<CR>", keymap_otps)
  nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", keymap_otps)

  if client.name == "tsserver" or client.name == "jsonls" then
    client.resolved_capabilities.document_formatting = false
  end

  -- Formatting on save
  if client.resolved_capabilities.document_formatting then
    cmd([[augroup Format]])
    cmd([[autocmd! * <buffer>]])
    cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]])
    cmd([[augroup END]])
  end

  -- Alias
  cmd([[command! LspFormat lua vim.lsp.buf.formatting()]])
  cmd([[command! LspSignature lua vim.lsp.buf.signature_help()]])
end

local custom_capabilities = function()
  local capabilities = require("cmp_nvim_lsp").update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )
  return capabilities
end

local function init_lsp()
  local DEFAULT_CONFIG = {
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
