local Utils = require "utils"

local nmap, imap = Utils.nmap, Utils.imap

require "lspsaga".init_lsp_saga {
    error_sign = "✖ ",
    warn_sign = "",
    hint_sign = "",
    infor_sign = "",
    border_style = "round",
    rename_prompt_prefix = " 🌈 ",
    rename_action_keys = {
        quit = "<esc>"
    }
}

local opts = {noremap = true}

-- signature help in insert mode
imap("<C-k>", [[<CMD>lua require"lspsaga.signaturehelp".signature_help()<CR>]], opts)
-- Diagnostics navigation
nmap("<C-k>", [[<CMD>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()<CR>]], opts)
nmap("<C-j>", [[<CMD>lua require"lspsaga.diagnostic".lsp_jump_diagnostic_next()<CR>]], opts)
-- Scrolling
nmap("<leader>[", [[<CMD>lua require"lspsaga.action".smart_scroll_with_saga(1)<CR>]], opts)
nmap("<leader>]", [[<CMD>lua require"lspsaga.action".smart_scroll_with_saga(-1)<CR>]], opts)
-- Definition and references
nmap("gh", [[<CMD>lua require"lspsaga.provider".lsp_finder()<CR>]], opts)
nmap("K", [[<CMD>lua require"lspsaga.hover".render_hover_doc()<CR>]], opts)
