set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'marcweber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'kwbdi.vim'

" --- Making Vim look good ---
Plugin 'joshdick/onedark.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" --- Programmer editor ---
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'mileszs/ack.vim'
Plugin 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plugin 'wincent/terminus'
Plugin 'ervandew/supertab'
Plugin 'anyakichi/vim-surround'
Plugin 'janko-m/vim-test'
Plugin 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }

" --- Completion/Snippets ---
Plugin 'Raimondi/delimitMate'
Plugin 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plugin 'zchee/deoplete-go', { 'do': 'make'}
Plugin 'Shougo/neosnippet.vim'

" --- Linters
Plugin 'w0rp/ale'

" --- Frontend
Plugin 'ap/vim-css-color'

" --- JavaScript
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'wokalski/autocomplete-flow'
Plugin 'heavenshell/vim-jsdoc'
Plugin 'carlitux/deoplete-ternjs', { 'do': 'yarn global tern','for': ['javascript', 'javascript.jsx'] }
Plugin 'ternjs/tern_for_vim', { 'do': 'npm install','for': ['javascript', 'javascript.jsx'] }

" --- Python
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'hdima/python-syntax'
Plugin 'deoplete-plugins/deoplete-jedi'

" --- Go
Plugin 'fatih/vim-go'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
"

" Theme
"
syntax on
set background=dark
colorscheme onedark

" ColorScheme for diff mode
" New Line
hi DiffAdd ctermbg=10 guibg=#e6ffed cterm=NONE gui=NONE
" Changed Line
hi DiffChange ctermbg=10 ctermfg=Black guibg=#e6ffed cterm=NONE gui=NONE
" Changed Text
hi DiffText ctermbg=34 guibg=#acf2bd cterm=bold gui=bold
" Deleted Line
hi DiffDelete ctermbg=9 guibg=#fdb8c0 cterm=NONE gui=NONE

set nowrap
set noea
set nofoldenable
set noerrorbells
set nobackup
set noswapfile

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

let g:delimitMate_expand_cr=1
let g:onedark_terminal_italics=1
let g:onedark_termcolors = 256

" --- Settings for different code
autocmd FileType neosnippet setlocal ts=4 sw=4 expandtab
autocmd FileType make setlocal noexpandtab
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype htmldjango setlocal ts=2 sw=2 expandtab
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
autocmd Filetype eruby setlocal ts=2 sw=2 expandtab
autocmd Filetype json setlocal ts=2 sw=2 expandtab foldmethod=marker foldmarker={,}
autocmd Filetype python setlocal ts=4 sw=4 softtabstop=4 expandtab foldmethod=indent
autocmd Filetype scss setlocal ts=2 sw=2 expandtab
autocmd Filetype yaml setlocal ts=2 sw=2 expandtab
autocmd Filetype go setlocal ts=4 sw=4 noexpandtab
autocmd Filetype javascript setlocal ts=2 sw=2 expandtab foldmethod=syntax
autocmd Filetype javascript.jsx setlocal ts=2 sw=2 expandtab foldmethod=syntax

" --- Shortcuts
"  Switch buffer next or previous
nnoremap <silent> <C-h> :bp<CR>
nnoremap <silent> <C-l> :bn<CR>

"  Open  nvim terminal in split or vertival split
nnoremap <silent> <C-t>s :split term://
nnoremap <silent> <C-t>v :vsplit term://
tnoremap <silent> <ESC> <C-\><C-n>

"  Move lines in <Normal> and <Visual>
"  ∆ for <Option-j> up and ˚ for <Option-k> down
nnoremap <silent> ∆ :m .+1<CR>==
nnoremap <silent> ˚ :m .-2<CR>==
vnoremap <silent> ∆ :m '>+1<CR>gv=gv
vnoremap <silent> ˚ :m '<-2<CR>gv=gv

"  Diff mode
if &diff
    nnoremap <silent> [c [c zz
    nnoremap <silent> ]c ]c zz
endif

"  Go To Definition
augroup filetype_go
    autocmd FileType go noremap <silent> <Leader>gds :sp <CR> :exe 'GoDef' <CR> <C-w>w zz
    autocmd FileType go noremap <silent> <Leader>gdv :vsp <CR> :exe 'GoDef' <CR> <C-w>w zz
    autocmd FileType go noremap <silent> <Leader>gdt :tab split <CR> :exe 'GoDef' <CR> zz
augroup END
augroup filetype_javascript
    autocmd FileType javascript,javascript.jsx noremap <silent> <Leader>gds :sp <CR> :exe 'TernDef' <CR> zz
    autocmd FileType javascript,javascript.jsx noremap <silent> <Leader>gdv :vsp <CR> :exe 'TernDef' <CR> zz
    autocmd FileType javascript,javascript.jsx noremap <silent> <Leader>gdt :tab split <CR> :exe 'TernDef' <CR> zz
augroup END

"  Terminal Stuff
augroup TerminalStuff
    autocmd!
    if v:progname == "nvim"
        autocmd TermOpen * setlocal nonumber norelativenumber
    endif
augroup END

augroup CursorLine
    autocmd!
    autocmd BufEnter * if !&diff | setlocal nocursorline | endif
augroup END


" --- Plugins ---

" --- ack options
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" --- Airline
let g:airline_theme='onedark'
" let g:airline_theme='luna'
let g:airline_powerline_fonts = 1
" enable tabline
let g:airline#extensions#tabline#enabled = 1
set laststatus=2
set noshowmode

" --- Gitgutter
set updatetime=100
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = 'o'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = 'w'

" --- NERDTree
" To have NERDTree always open on startup
let g:nerdtree_tabs_open_on_console_startup = 0
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeIgnore=['node_modules', '\.pyc$', '.DS_Store', '\.class$', '__pycache__']
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

" --- Deoplete.
if has('python3')
    let g:deoplete#enable_at_startup = 1
endif

" --- Neosnippet
let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#snippets_directory='~/.vim/snippets'
let g:neosnippet#disable_runtime_snippets = {
\   '_' : 1,
\ }

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" --- Supertabs
let g:SuperTabDefaultCompletionType = "<c-n>"

" --- ALE
let g:ale_linters = {
\   'javascript': ['eslint', 'flow'],
\   'go': ['gofmt'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier'],
\   'html': ['prettier'],
\   'css': ['prettier'],
\   'go': ['goimports'],
\}
" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_completion_enabled = 1
let g:ale_echo_msg_format = '[%severity%] [%linter%] - %s'

" --- LeaderF
let g:Lf_ShortcutF = '<C-P>'
let g:Lf_WildIgnore = {
\   'dir': ['.svn','.git','.hg', 'node_modules'],
\   'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
\}


" --- JavaScript ---
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1

" --- JSDocs
let g:jsdoc_enable_es6 = 1
let g:jsdoc_underscore_private = 1
let g:jsdoc_access_descriptions = 2

" ---Python ---

" --- Python Syntax
let python_highlight_all = 1
