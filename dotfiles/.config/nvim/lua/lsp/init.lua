local Utils = require "utils"

local lspconfig = require "lspconfig"

local nmap, cmd = Utils.nmap, Utils.cmd

local on_attach = function(client)
    -- Keymap
    local keymap_otps = {noremap = true, silent = true}

    nmap("gb", "<C-o>", keymap_otps)
    nmap("gd", "<cmd>Telescope lsp_definitions<CR>zz", keymap_otps)
    nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>zz", keymap_otps)
    nmap("gr", "<cmd>Telescope lsp_references<CR>", keymap_otps)
    nmap("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", keymap_otps)
    -- nmap("K", "<cmd>lua vim.lsp.buf.hover()<CR>", keymap_otps)
    -- nmap("<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keymap_otps)
    -- nmap("<C-b>", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", keymap_otps)
    -- nmap("<C-n>", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", keymap_otps)

    if client.name == "tsserver" then
        client.resolved_capabilities.document_formatting = false
    end

    -- Formatting on save
    if client.resolved_capabilities.document_formatting then
        cmd [[augroup Format]]
        cmd [[autocmd! * <buffer>]]
        cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
        cmd [[augroup END]]
    end

    -- Alias
    cmd [[command! LspFormat lua vim.lsp.buf.formatting()]]
    cmd [[command! LspSignature lua vim.lsp.buf.signature_help()]]
end

local custom_capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return capabilities
end

local lsp_packages = {
    bashls = "bash-lsp",
    efm = "efm-lsp",
    flow = "flow-lsp",
    gopls = "go-lsp",
    vimls = "vim-lsp",
    jsonls = "json-lsp",
    html = "html-lsp",
    cssls = "css-lsp",
    sumneko_lua = "sumneko-lsp",
    tsserver = "ts-lsp"
}

for server, pkg_name in pairs(lsp_packages) do
    local config = require("lsp/" .. pkg_name)

    lspconfig[server].setup(
        vim.tbl_deep_extend(
            "force",
            {
                on_attach = on_attach,
                capabilities = config.capabilities or custom_capabilities()
            },
            config
        )
    )
end

-- Automatically update diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = {
            prefix = " ●",
            spacing = 4
        },
        signs = true,
        update_in_insert = false
    }
)

local signs = {Error = "✖ ", Warning = " ", Hint = " ", Information = " "}

for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
end
