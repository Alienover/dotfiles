local utils = require("utils")
local constants = require("utils.constants")

local nmap, imap = utils.nmap, utils.imap

local icons = constants.icons

local config = {
  -- Options with default value
  -- "single" | "double" | "rounded" | "bold" | "plus"
  border_style = "rounded",
  --the range of 0 for fully opaque window (disabled) to 100 for fully
  --transparent background. Values between 0-30 are typically most useful.
  saga_winblend = 0,
  -- when cursor in saga window you config these to move
  move_in_saga = { prev = "<C-p>", next = "<C-n>" },
  -- Error, Warn, Info, Hint
  -- use emoji like
  -- { "🙀", "😿", "😾", "😺" }
  -- or
  -- { "😡", "😥", "😤", "😐" }
  -- and diagnostic_header can be a function type
  -- must return a string and when diagnostic_header
  -- is function type it will have a param `entry`
  -- entry is a table type has these filed
  -- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
  diagnostic_header = {
    icons.ERROR,
    icons.WARN,
    icons.INFOR,
    icons.HINT,
  },
  -- use emoji lightbulb in default
  code_action_icon = icons.HINT,
  -- if true can press number to execute the codeaction in codeaction window
  code_action_num_shortcut = true,
  -- same as nvim-lightbulb but async
  code_action_lightbulb = {
    enable = false,
    sign = true,
    sign_priority = 20,
    virtual_text = true,
  },
  -- finder icons
  finder_icons = {
    def = "  ",
    ref = "諭 ",
    link = icons.ui.ChevronRight .. " ",
    -- link = icons.ui.ChevronRight .. " ",
  },
  -- preview lines of lsp_finder and definition preview
  max_preview_lines = 10,
  finder_action_keys = {
    split = "s",
    vsplit = "v",
    scroll_up = "<C-u>",
    scroll_down = "<C-d>",
    quit = { "q", "<esc>" },
  },
  code_action_keys = { "q", "<esc>" },
  rename_action_quit = "<C-c>",
  -- definition_preview_icon = "  ",
  -- show symbols in winbar must nightly
  symbol_in_winbar = {
    in_custom = true,
    enable = utils.has_nvim_08,
    separator = " " .. icons.ui.ChevronRight .. " ",
    show_file = false,
    click_support = false,
  },

  -- if you don't use nvim-lspconfig you must pass your server name and
  -- the related filetypes into this table
  -- like server_filetype_map = { metals = { "sbt", "scala" } }
  server_filetype_map = {},
}

require("lspsaga").init_lsp_saga(config)

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
nmap("K", lspsaga("hover_doc"), opts)
