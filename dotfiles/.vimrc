set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/.vim/plugged')
" Plugins go here
Plug 'marcweber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'vim-scripts/kwbdi.vim'

" --- Making Vim look good ---
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" --- Programmer editor ---
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'janko-m/vim-test'
Plug 'mileszs/ack.vim'
Plug 'wincent/terminus'
Plug 'ervandew/supertab'
Plug 'anyakichi/vim-surround'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
Plug 'editorconfig/editorconfig-vim'

" --- Completion/Snippets ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" --- Frontend
Plug 'ap/vim-css-color'

" --- JavaScript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'heavenshell/vim-jsdoc'

" --- Python
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'hdima/python-syntax'

" --- Go
Plug 'fatih/vim-go'

call plug#end()

filetype plugin indent on

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

let g:onedark_terminal_italics=1
let g:onedark_termcolors = 256

" --- Settings for different code
" Remove trailing spaces before saving
" autocmd FileWritePre * call TrimWhiteSpace()
" autocmd FileAppendPre * call TrimWhiteSpace()
" autocmd FilterWritePre * call TrimWhiteSpace()
" autocmd BufWritePre * call TrimWhiteSpace()

autocmd FileType neosnippet setlocal ts=4 sw=4 expandtab
autocmd FileType cpp setlocal ts=2 sw=2 expandtab
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
nnoremap <C-t> :terminal<CR>i
tnoremap <silent> <ESC> <C-\><C-n>

"  Move lines in <Normal> and <Visual>
"  ∆ for <Option-j> up and ˚ for <Option-k> down
nnoremap <silent> ∆ :m .+1<CR>==
nnoremap <silent> ˚ :m .-2<CR>==
vnoremap <silent> ∆ :m '>+1<CR>gv=gv
vnoremap <silent> ˚ :m '<-2<CR>gv=gv

nnoremap <silent> <leader>r :source $HOME/.vimrc<CR>

"  Diff mode
if &diff
    nnoremap <silent> [c [c zz
    nnoremap <silent> ]c ]c zz
endif

"  Go To Definition
augroup filetype_go
    autocmd FileType go noremap <silent> gd :exe 'GoDef' <CR> zz
    " autocmd FileType go noremap <silent> gds :sp <CR> :exe 'GoDef' <CR>
    " autocmd FileType go noremap <silent> gdv :vsp <CR> :exe 'GoDef' <CR>
    " autocmd FileType go noremap <silent> gdt :tab split <CR> :exe 'GoDef' <CR> zz
    " Run GoImports to format and import missing packages before saving
    autocmd FileType go autocmd BufWritePre <buffer> GoImports
augroup END
augroup filetype_javascript
    autocmd Filetype javascript,javascript.jsx nmap <silent> gd <Plug>(coc-definition) zz
augroup END

"  Terminal Stuff
augroup terminal_stuff
    autocmd!
    if v:progname == "nvim"
        autocmd TermOpen * setlocal nonumber norelativenumber
    endif
augroup END

" augroup cursor_line
"     autocmd!
"     autocmd BufEnter * if !&diff | setlocal nocursorline | endif
" augroup END

" --- Plugins ---

" --- ack options
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

" --- Airline
let g:airline_theme = 'onedark'
" let g:airline_theme='luna'
let g:airline_powerline_fonts = 1
" enable tabline
let g:airline#extensions#tabline#enabled = 1
" enable/disable coc integration
" let g:airline#extensions#coc#enabled = 1
" " change error symbol
" let airline#extensions#coc#error_symbol = 'E:'
" " change warning symbol
" let airline#extensions#coc#warning_symbol = 'W:'
" " change error format
" let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
" " change warning format
" let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

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
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeDirArrows = 1
let NERDTreeIgnore=['node_modules', '\.pyc$', '.DS_Store', '\.class$', '__pycache__']
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

" --- CoC
set updatetime=100
set shortmess+=c
let g:coc_global_extensions = ['coc-html', 'coc-json']

" --- Coc Prettier
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

" --- Supertabs
let g:SuperTabDefaultCompletionType = "<c-n>"

" --- JavaScript ---
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1

" --- JSDocs
let g:jsdoc_enable_es6 = 1
let g:jsdoc_underscore_private = 1
let g:jsdoc_access_descriptions = 2

" --- Python ---

" --- Python Syntax
let python_highlight_all = 1

" --- Go ---
let g:go_def_mapping_enabled = 0

" ------------------------
" --- Custom Functions ---
" ------------------------
"  Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
" Z(z)oom O(o)pen := Zoom in/out the split window
nnoremap <silent> zo :ZoomToggle<CR>


"  If installed using Homebrew
set rtp+=/usr/local/opt/fzf
let $FZF_DEFAULT_COMMAND = "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
let $FZF_DEFAULT_OPTS="--color fg:242,bg:236,hl:114,fg+:15,bg+:236,hl+:114,info:108,prompt:109,spinner:108,pointer:114,marker:173 --layout=reverse --margin=1,2"
"  Default fzf layout
let g:fzf_layout = { 'window': 'call OpenFloatingWin()' }

function! OpenFloatingWin(...)
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = float2nr(30)
    let width = float2nr(80)
    let horizontal = float2nr((&columns - width) / 2)
    let vertical = 1

    if a:0 > 0
        if a:1
            let height = float2nr(a:1)
        endif
        if a:2
            let width = float2nr(a:2)
        endif
    endif

    let opts = {
            \ 'relative': 'editor',
            \ 'row': vertical,
            \ 'col': horizontal,
            \ 'width': width,
            \ 'height': height,
            \ 'style': 'minimal'
            \ }

    call nvim_open_win(buf, v:true, opts)
    tnoremap <ESC> <C-c>
endfunction

" -------------------------------
" FZF - Files
" -------------------------------
function! s:BFiles()
    let source = "find * -path '*/\.*' -prune -o -path 'node_modules' -prune -o -path '**/node_modules' -prune -o -path 'target/**' -prune -o -path 'dist' -prune -o -path '**/dist' -prune -o  -type f -print -o -type l -print 2> /dev/null"
    let options = $FZF_DEFAULT_OPTS . " " . "--preview 'if file -i {}|grep -q binary; then file -b {}; else bat --style=changes --color always --line-range :40 {}; fi' --preview-window bottom"

    call fzf#run(fzf#wrap({
                \ 'source': source,
                \ 'options': options,
                \}))
endfunction
command! BFiles call s:BFiles()
nnoremap <silent> <C-P> :BFiles<CR>

" -------------------------------
" FZF - Folders
" -------------------------------
function! s:BFolders()
    let source = "find * -path '*/\.*' -prune -o -path 'target/**' -prune -o -path 'dist' -print -o -path '**/dict' -prune -o -type d -print -o -type l -print 2> /dev/null"
    let sink = "NERDTree"
    let options = $FZF_DEFAULT_OPTS . " " . "--preview 'tree -L 1 -C {}' --preview-window bottom"
    call fzf#run(fzf#wrap({
                \ 'source': source,
                \ 'options': options,
                \ 'sink': sink,
                \ }))
endfunction
command! BFolders call s:BFolders()
nnoremap <silent> <C-F> :BFolders<CR>

" -------------------------------
" FZF - Buffers
" -------------------------------
function! s:jump_buffer(e)
    let b = matchstr(a:e, '^[ 0-9]*')
    execute 'buffer' b
endfunction

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:BBuffers()
    let source = s:buflist()
    let options = $FZF_DEFAULT_OPTS . ' ' . '--prompt "Buffers > " --no-preview'
    call fzf#run(fzf#wrap({
                \ 'source': source,
                \ 'options': options,
                \ 'sink': function("s:jump_buffer"),
                \ 'window': "call OpenFloatingWin(10, 80)"
                \ }))
endfunction
command! BBuffers call s:BBuffers()
nnoremap <silent> <C-B> :BBuffers<CR>
