local Utils = require "utils"

local o, bo, wo, g = Utils.o, Utils.bo, Utils.wo, Utils.g

local cmd = Utils.cmd

-- be iMproved, required
cmd [[set nocompatible]]
cmd [[filetype plugin indent on]]

cmd [[syntax on]]

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
bo.swapfile = false
wo.foldenable = false

-- set updatetime=100
o.lsp = 3
o.pumheight = 15
o.laststatus = 2
o.shiftwidth = 4
o.history = 1000
-- Disable the native suggestion list
o.spellsuggest = "0"
o.undolevels = 1000
o.encoding = "utf-8"
o.clipboard = "unnamed"
o.backspace = "indent,eol,start"
o.wildignore = "*.swp, *.bak, *.pyc, *.class"

o.fillchars = "diff:╱"
wo.fillchars = "diff:╱"

-- Python for neovim
cmd [[
    let g:python_venv_home = $VIRTUALENVWRAPPER_HOOK_DIR . '/neovim_py2'
    let g:python3_venv_home = $VIRTUALENVWRAPPER_HOOK_DIR . '/neovim_py3'

    let g:python_venv_bin = g:python_venv_home . '/bin/python'
    let g:python3_venv_bin = g:python3_venv_home . '/bin/python'

    if filereadable(g:python_venv_bin)
	let g:python_host_prog = g:python_venv_bin
    endif

    if filereadable(g:python3_venv_bin)
	let g:python3_host_prog = g:python3_venv_bin
    endif
]]
