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

-- Formatting on save
vim.api.nvim_command [[augroup Format]]
vim.api.nvim_command [[autocmd! * <buffer>]]
vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
vim.api.nvim_command [[augroup END]]

-- Alias
vim.api.nvim_command [[command! LspFormat lua vim.lsp.buf.formatting()]]
vim.api.nvim_command [[command! LspSignature lua vim.lsp.buf.signature_help()]]

-- Automatically update diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = {spacing = 4, prefix = "●"},
        severity_sort = true
    }
)

local signs = {Error = "✖ ", Warning = " ", Hint = " ", Information = " "}

for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
end
