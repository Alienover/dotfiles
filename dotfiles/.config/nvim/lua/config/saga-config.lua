local utils = require("utils")
local constants = require("utils.constants")

local nmap, imap = utils.nmap, utils.imap

local icons = constants.icons

require("lspsaga").init_lsp_saga({
  error_sign = icons.ERROR,
  warn_sign = icons.WARN,
  hint_sign = icons.HINT,
  infor_sign = icons.INFOR,
  border_style = "round",
  rename_prompt_prefix = " 🌈 ",
  rename_action_keys = {
    quit = "<esc>",
  },
})

local opts = { noremap = true }

-- signature help in insert mode
imap("<C-k>", [[<CMD>Lspsaga signature_help<CR>]], opts)
-- Diagnostics navigation
nmap("<C-k>", [[<CMD>Lspsaga diagnostic_jump_prev<CR>]], opts)
nmap("<C-j>", [[<CMD>Lspsaga diagnostic_jump_next<CR>]], opts)
-- Scrolling
nmap(
  "<leader>[",
  [[<CMD>lua require"lspsaga.action".smart_scroll_with_saga(1)<CR>]],
  opts
)
nmap(
  "<leader>]",
  [[<CMD>lua require"lspsaga.action".smart_scroll_with_saga(-1)<CR>]],
  opts
)
-- Definition and references
nmap("gh", [[<CMD>Lspsaga lsp_finder<CR>]], opts)
nmap("K", [[<CMD>Lspsaga hover_doc<CR>]], opts)

-- -- Rewrite the mappings due to the lspsaga issues in v5.1 and nightly
-- imap("<C-k>", [[<CMD>lua vim.lsp.buf.signature_help()<CR>]], opts)
-- nmap("<C-k>", [[<CMD>lua vim.lsp.diagnostic.goto_next()<CR>]], opts)
-- nmap("<C-j>", [[<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>]], opts)
-- nmap("K", [[<CMD>lua vim.lsp.buf.hover()<CR>]], opts)
