local lspconfig = require "lspconfig"

local on_attach = function(client)
    -- Keymap
    local keymap_otps = {noremap = true, silent = true}
    vim.api.nvim_set_keymap("n", "gb", "<C-o><CR>", keymap_otps)
    vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", keymap_otps)
    vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", keymap_otps)
    vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", keymap_otps)
    vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", keymap_otps)
    vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", keymap_otps)
    vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keymap_otps)
    vim.api.nvim_set_keymap("n", "<C-b>", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", keymap_otps)
    vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", keymap_otps)

    if client.name == "tsserver" then
        client.resolved_capabilities.document_formatting = false
    end

    -- Formatting on save
    if client.resolved_capabilities.document_formatting then
        vim.api.nvim_command [[augroup Format]]
        vim.api.nvim_command [[autocmd! * <buffer>]]
        vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
        vim.api.nvim_command [[augroup END]]
    end

    -- Alias
    vim.api.nvim_command [[command! LspFormat lua vim.lsp.buf.formatting()]]
    vim.api.nvim_command [[command! LspSignature lua vim.lsp.buf.signature_help()]]
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
