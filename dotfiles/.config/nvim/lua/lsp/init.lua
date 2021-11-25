local Utils = require("utils")

local lspconfig = require("lspconfig")
local lspinstaller = require("nvim-lsp-installer")

local nmap, cmd = Utils.nmap, Utils.cmd

local icons = Utils.icons

local LSP_SOURCES = {
    MANUAL = 0,
    INSTALLER = 1,
}

local installed_lsp = {
    ["null-ls"] = {
        filename = "null-lsp",
        source = LSP_SOURCES.MANUAL,
    },
    -- `npm` required
    flow = {
        filename = "flow-lsp",
        source = LSP_SOURCES.MANUAL,
    },
    html = {
        filename = "",
        source = LSP_SOURCES.INSTALLER,
    },
    cssls = {
        filename = "",
        source = LSP_SOURCES.INSTALLER,
    },
    vimls = {
        filename = "",
        source = LSP_SOURCES.INSTALLER,
    },
    jsonls = {
        filename = "json-lsp",
        source = LSP_SOURCES.INSTALLER,
    },
    bashls = {
        filename = "",
        source = LSP_SOURCES.INSTALLER,
    },
    tsserver = {
        filename = "ts-lsp",
        source = LSP_SOURCES.INSTALLER,
    },
    tailwindcss = {
        filename = "",
        source = LSP_SOURCES.INSTALLER,
    },
    pyright = {
        filename = "",
        source = LSP_SOURCES.INSTALLER,
    },
    -- `go` required
    gopls = {
        -- NOTE: `sudo` required
        filename = "go-lsp",
        source = LSP_SOURCES.INSTALLER,
    },
    -- `git` required
    sumneko_lua = {
        filename = "sumneko-lsp",
        source = LSP_SOURCES.INSTALLER,
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
        cmd(
            [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
        )
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

            if
                pcall(function()
                    require(config_filename)
                end)
            then
                config = require(config_filename)
            end
        end

        return vim.tbl_deep_extend("force", DEFAULT_CONFIG, config)
    end

    -- Setup the lsp for the one installed manually
    for server, opts in pairs(installed_lsp) do
        if opts.source == LSP_SOURCES.MANUAL then
            local config = load_config(opts.filename)

            lspconfig[server].setup(config)
        end
    end

    -- Setup the lsp for the one from installer
    lspinstaller.on_server_ready(function(server)
        local config = {}
        local opts = installed_lsp[server.name]

        if opts ~= nil then
            config = load_config(opts.filename)
        end

        server:setup(config)
    end)
end

for name, _ in pairs(installed_lsp) do
    local existed, server = lspinstaller.get_server(name)
    if existed then
        if not server:is_installed() then
            server:install()
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
        update_in_insert = false,
    }
)

local signs = {
    Error = icons.ERROR,
    Warning = icons.WARN,
    Hint = icons.HINT,
    Information = icons.INFOR,
}

for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
