require "lspsaga".init_lsp_saga {
    error_sign = "E",
    warn_sign = "W",
    hint_sign = ">",
    infor_sign = ">",
    code_action_icon = "> ",
    dianostic_header_icon = "! ",
    definition_preview_icon = "> ",
    finder_definition_icon = "> ",
    finder_reference_icon = "> ",
    border_style = "round",
    code_action_prompt = {enable = true, sign = true, sign_priority = 20, virtual_text = false},
    finder_action_keys = {
        open = "e",
        vsplit = "v",
        split = "s",
        quit = "q",
        scroll_down = "<C-d>",
        scroll_up = "<C-u>" -- quit can be a table
    },
    code_action_keys = {quit = "<ESC>", exec = "<CR>"}
}

-- vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>Lspsaga diagnostic_jump_next<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<C-m>", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>Lspsaga signature_help<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", {noremap = true, silent = true})
