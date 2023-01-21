local utils = require("utils")
local constants = require("utils.constants")

local nmap, imap = utils.nmap, utils.imap

local icons, colors = constants.icons, constants.colors

local config = {
  ui = {
    border = "rounded",
    colors = {
      normal_bg = colors.BG,
      red = colors.RED,
      green = colors.GREEN,
    },
  },
  diagnostic = {
    show_code_action = false,
  },
  lightbulb = {
    enable = false,
  },
  code_action = {
    num_shortcut = false,
    keys = {
      -- string |table type
      quit = "q",
      exec = "<CR>",
    },
  },
  symbol_in_winbar = {
    enable = true,
    hide_keyword = true,
    show_file = false,
    click_support = false,
    color_mode = true,
    separator = " " .. icons.ui.ChevronRight .. " ",
  },
}

require("lspsaga").setup(config)

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
nmap("gp", lspsaga("peek_definition"), opts)
-- INFO: moving "K" to keymappings.lua
-- nmap("K", lspsaga("hover_doc"), opts)
