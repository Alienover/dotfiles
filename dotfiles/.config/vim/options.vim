set nocompatible              " be iMproved, required
filetype off                  " required

filetype plugin indent on

" Theme
"
syntax on
set background=dark
colorscheme onedark

let g:onedark_terminal_italics=1
let g:onedark_termcolors = 256

" ColorScheme for diff mode
" New Line
hi DiffAdd ctermbg=10 guibg=#e6ffed cterm=NONE gui=NONE
" Changed Line
hi DiffChange ctermbg=10 ctermfg=Black guibg=#e6ffed cterm=NONE gui=NONE
" Changed Text
hi DiffText ctermbg=34 guibg=#acf2bd cterm=bold gui=bold
" Deleted Line
hi DiffDelete ctermbg=9 guibg=#fdb8c0 guifg=#5C6370 cterm=NONE gui=NONE

set nowrap
set noea
set nofoldenable
set noerrorbells
set nobackup
set noswapfile
set noshowmode

set title
set number
set visualbell
set autoindent
set copyindent
set expandtab
set shiftround
set showmatch
set showcmd
set ignorecase
set smartcase
set smarttab
set hlsearch
set incsearch
set wrap
set relativenumber
set cursorline

" set updatetime=100
set pumheight=15
set laststatus=2
set encoding=utf-8
set linespace=3
set backspace=indent,eol,start
set shiftwidth=4
set history=1000
set undolevels=1000
set clipboard=unnamed
set wildignore=*.swp,*.bak,*.pyc,*.class
set guioptions-=r
set guioptions-=L

let g:python_venv_home = $VIRTUALENVWRAPPER_HOOK_DIR . '/neovim_py2'
let g:python3_venv_home = $VIRTUALENVWRAPPER_HOOK_DIR . '/neovim_py3'

let g:python_venv_bin = g:python_venv_home . '/bin/python'
let g:python3_venv_bin = g:python3_venv_home . '/bin/python'

" Python2 for neovim
if filereadable(g:python_venv_bin)
    let g:python_host_prog = g:python_venv_bin
endif

" Python3 for neovim
if filereadable(g:python3_venv_bin)
    let g:python3_host_prog = g:python3_venv_bin
endif
