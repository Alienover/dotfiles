local utils = require("utils")
local constants = require("utils.constants")

local cmd = utils.cmd

cmd([[syntax on]])

cmd([[filetype on]])

cmd([[filetype plugin indent on]])

-- set updatetime=100
-- FIXME: what's `vim.o.lsp`
-- vim.o.lsp = 3

-- Global variables
local global = {
  loaded_gzip = 1,
  loaded_tar = 1,
  loaded_tarPlugin = 1,
  loaded_zip = 1,
  loaded_zipPlugin = 1,

  -- Disable the builtin NetRW plugin
  loaded_netrw = 1,
  loaded_netrwPlugin = 1,
  loaded_netrwSettings = 1,
  loaded_netrwFileHandlers = 1,

  -- Disable the builtin `matchit.vim`
  loaded_matchit = 1,
  loaded_matchparen = 1,

  -- Disble Perl support
  loaded_perl_provider = 0,

  -- Leader key mapping
  mapleader = "\\",

  -- Disable tab key in copilot
  copilot_no_tab_map = true,

  -- Python for neovim
  python_venv_home = os.getenv("VIRTUALENVWRAPPER_HOOK_DIR") .. "/neovim_py2",
  python3_venv_home = os.getenv("VIRTUALENVWRAPPER_HOOK_DIR") .. "/neovim_py3",

  -- Filetypes without illuminate
  Illuminate_ftblacklist = {
    "fugitiveblame",
    "checkhealth",
    "help",
    "lspsagafinder",
  },
  Illuminate_highlightUnderCursor = 0,
}

local python_venv_bin = global.python_venv_home .. "/bin/python"
local python3_venv_bin = global.python3_venv_home .. "/bin/python"

if vim.fn.executable(python_venv_bin) then
  global.python_host_prog = python_venv_bin
end

if vim.fn.executable(python3_venv_bin) then
  global.python3_host_prog = python3_venv_bin
end

-- Vim based Options
local options = {
  -- Base
  title = true,
  history = 1000,
  showcmd = true,
  showmatch = true,
  showmode = false,
  swapfile = false,
  copyindent = true,
  shiftround = true,
  splitbelow = true,
  splitright = true,
  visualbell = true,

  -- Search case matching
  smartcase = true,
  ignorecase = true,

  -- Number
  number = true,
  relativenumber = true,

  -- be iMproved, required
  compatible = false,

  -- Folding
  foldenable = false,
  -- NOTE: set the fold method on autocmd by filetypes or filenames
  -- foldmethod = "expr",
  -- foldexpr = "nvim_treesitter#foldexpr()",

  --  Count for the items in the menu popup
  pumheight = 15,

  -- Cursor line
  cursorline = true,

  -- Disable the native suggestion list
  spellsuggest = { "0" },

  -- Undo
  undofile = true,
  undolevels = 1000,

  encoding = "utf-8",
  clipboard = { "unnamed" },
  backspace = { "indent", "eol", "start" },
  wildignore = { "*.swp", "*.bak", "*.pyc" },

  -- Diff Mode
  fillchars = { diff = "╱" },

  -- List Mode
  list = true,
  listchars = { tab = "> ", lead = "·", trail = "·" },

  -- Spaces of indent
  shiftwidth = 2,
  tabstop = 2,
  expandtab = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

for k, v in pairs(global) do
  vim.g[k] = v
end

for _, v in pairs(constants.runtime_paths) do
  cmd("set rtp+=" .. v)
end
