" --- Shortcuts
"  Switch buffer next or previous
nnoremap <silent> <C-h> :bp<CR>
nnoremap <silent> <C-l> :bn<CR>

"  Open  nvim terminal in split or vertival split
nnoremap <silent> <C-t> :terminal<CR>i
"  Unfocus the terminal window
tnoremap <silent> <leader><ESC> <C-\><C-n>

"  Move lines in <Normal> and <Visual>
"  ∆ for <Option-j> up and ˚ for <Option-k> down
nnoremap <silent> ∆ :m .+1<CR>==
nnoremap <silent> ˚ :m .-2<CR>==
vnoremap <silent> ∆ :m '>+1<CR>gv=gv
vnoremap <silent> ˚ :m '<-2<CR>gv=gv

nnoremap <silent> <leader>r :source $HOME/.vimrc<CR>

"  Mapping for which key
nnoremap <silent> <Space> :WhichKey "<Space>"<CR>

"  Diff mode
if &diff
    nnoremap <silent> [c [c zz
    nnoremap <silent> ]c ]c zz
endif

" ------------------------
" --- Custom Functions ---
" ------------------------
"  Zoom / Restore window.
function! ZoomToggle() abort
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
" Z(z)oom O(o)pen := Zoom in/out the split window
nnoremap <silent> zo :call ZoomToggle()<CR>
