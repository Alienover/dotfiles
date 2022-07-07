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
  finder_action_keys = {
    split = "s",
    vsplit = "v",
    scroll_up = "<C-u>",
    scroll_down = "<C-d>",
    quit = { "q", "<esc>" },
  },
  code_action_prompt = {
    enable = false,
  },
  code_action_keys = {
    quit = { "q", "<esc>" },
  },
  definition_preview_action_keys = {
    open = "o",
    split = "s",
    vsplit = "v",
  },
})

local opts = { noremap = true }

local function lspsaga(sub_cmd)
  return function()
    utils.cmd("Lspsaga " .. sub_cmd)
  end
end

-- signature help in insert mode
imap("<C-k>", lspsaga("signature_help"), opts)
-- Diagnostics navigation
nmap("<C-k>", lspsaga("diagnostic_jump_prev"), opts)
nmap("<C-j>", lspsaga("diagnostic_jump_next"), opts)
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
nmap("gh", lspsaga("lsp_finder"), opts)
nmap("gp", lspsaga("preview_definition"), opts)
nmap("K", lspsaga("hover_doc"), opts)
