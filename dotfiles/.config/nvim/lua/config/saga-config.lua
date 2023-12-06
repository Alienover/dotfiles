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
    height = (1 - window_specing.t * 2),
    width = (1 - window_specing.l * 2),
  },
}

require("lspsaga").setup(config)

local function lspsaga(sub_cmd, opts)
  return function()
    local silent = (opts and opts.silent) or false

    if silent then
      vim.F.npcall(utils.cmd, "Lspsaga " .. sub_cmd)
    else
      utils.cmd("Lspsaga " .. sub_cmd)
    end
  end
end

-- signature help in insert mode
imap(
  "<C-k>",
  lspsaga("signature_help", { silent = true }),
  "LspSaga: Signature Help"
)
-- Diagnostics navigation
nmap("[d", lspsaga("diagnostic_jump_prev"), "LspSaga: Previous Diagnostic")
nmap("]d", lspsaga("diagnostic_jump_next"), "LspSaga: Next Diagnostic")
-- Definition and references
nmap("gh", lspsaga("finder"), "LspSaga: Finder")
nmap("gp", lspsaga("peek_definition"), "LspSaga: [G]o [P]eek")
