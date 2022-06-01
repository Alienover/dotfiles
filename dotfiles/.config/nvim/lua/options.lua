local utils = require("utils")

local o, bo, wo, g = utils.o, utils.bo, utils.wo, utils.g

local cmd = utils.cmd

cmd([[filetype plugin indent on]])

cmd([[syntax on]])

-- Do not source the default filetype.vim
g.did_load_filetypes = 1

-- be iMproved, required
o.compatible = false

-- Leader key mapping
g.mapleader = "\\"

o.title = true
o.visualbell = true
bo.copyindent = true
bo.expandtab = true
o.shiftround = true
o.showmatch = true
wo.cursorline = true
wo.relativenumber = true
o.smartcase = true
o.ignorecase = true
o.showcmd = true
o.showmatch = true
o.shiftround = true
wo.number = true
o.showmode = false
o.swapfile = false
bo.swapfile = false

-- Folding
wo.foldenable = false
wo.foldmethod = "expr"
wo.foldexpr = "nvim_treesitter#foldexpr()"

-- set updatetime=100
o.lsp = 3
o.pumheight = 15
o.laststatus = 2
o.shiftwidth = 4
o.history = 1000
-- Disable the native suggestion list
o.spellsuggest = "0"
-- Undo
bo.undofile = true
o.undolevels = 1000

o.encoding = "utf-8"
o.clipboard = "unnamed"
o.backspace = "indent,eol,start"
o.wildignore = "*.swp, *.bak, *.pyc, *.class"

-- Diff mode
o.fillchars = "diff:╱"
wo.fillchars = "diff:╱"

-- Llist mode
wo.list = true
wo.listchars = "tab: ,lead:·,trail:·"

g.copilot_no_tab_map = true

-- Python for neovim
g.python_venv_home = os.getenv("VIRTUALENVWRAPPER_HOOK_DIR") .. "/neovim_py2"
g.python3_venv_home = os.getenv("VIRTUALENVWRAPPER_HOOK_DIR") .. "/neovim_py3"

g.python_venv_bin = g.python_venv_home .. "/bin/python"
g.python3_venv_bin = g.python3_venv_home .. "/bin/python"

if vim.fn.executable(g.python_venv_bin) then
  g.python_host_prog = g.python_venv_bin
end

if vim.fn.executable(g.python3_venv_bin) then
  g.python3_host_prog = g.python3_venv_bin
end
