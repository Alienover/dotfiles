" --- NERDTree
" To have NERDTree always open on startup
let g:nerdtree_tabs_open_on_console_startup = 0
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeDirArrows = 1
let NERDTreeMinimalUI = 1
let NERDTreeIgnore=['node_modules', '\.pyc$', '.DS_Store', '\.class$', '__pycache__']

" Toggle
nnoremap <silent> <C-f> :NERDTreeFocus<CR>
" Reveal current file
nnoremap <silent> <leader>f :NERDTreeFind<CR>zz

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
