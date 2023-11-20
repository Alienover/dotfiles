local utils = require("utils")
local constants = require("utils.constants")

local nmap, imap = utils.nmap, utils.imap

local icons = constants.icons

local window_specing = utils.get_window_default_spacing()

local config = {
  ui = {
    -- currently only round theme
    colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
    kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
    border = "rounded",
  },
  finder = {
    max_height = 0.2,
    keys = {
      vsplit = "v",
      toggle_or_open = "<CR>",
    },
  },
  diagnostic = {
    show_code_action = false,
  },
  lightbulb = {
    enable = false,
  },
  code_action = {
    extend_gitsigns = true,
    num_shortcut = false,
    keys = {
      -- string |table type
      quit = "q",
      exec = "<CR>",
    },
  },
  symbol_in_winbar = {
    enable = false,
    hide_keyword = true,
    show_file = false,
    click_support = false,
    color_mode = true,
    separator = " " .. icons.ui.ChevronRight .. " ",
  },
  floaterm = {
    height = window_specing.t * 2,
    width = window_specing.l * 2,
  },
}

require("lspsaga").setup(config)

local opts = { noremap = true }

local function d(desc)
  local o = vim.deepcopy(opts)
  if desc then
    o.desc = "LSP: " .. desc
  end

  return o
end

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
nmap("gh", lspsaga("finder"), opts)
nmap("gp", lspsaga("peek_definition"), d("[G]o [P]eek"))
