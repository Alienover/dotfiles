" Make Ranger replace netrw and be the file explorer
" let g:rnvimr_vanilla = 1
let g:rnimr_ex_enable = 1
let g:rnvimr_draw_border = 1
let g:rnvimr_enable_picker = 1
let g:rnvimr_enable_bw = 1
let g:rnvimr_ranger_cmd = g:python3_venv_home . '/bin/ranger'

" Add views for Ranger to adapt the size of floating window
let g:rnvimr_ranger_views = [
            \ {'minwidth': 90, 'ratio': [1,2,3]},
            \ {'minwidth': 50, 'maxwidth': 89, 'ratio': [1,2]},
            \ {'maxwidth': 49, 'ratio': [1]}
            \ ]

" Customize the initial layout
let g:rnvimr_layout = {
            \ 'relative': 'editor',
            \ 'width': float2nr(round(0.5 * &columns)),
            \ 'height': float2nr(round(0.5 * &lines)),
            \ 'col': float2nr(round(0.25 * &columns)),
            \ 'row': float2nr(round(0.25 * &lines)),
            \ 'style': 'minimal'
            \ }

" Link CursorLine into RnvimrNormal highlight in the Floating window
highlight link RnvimrNormal CursorLine

if filereadable(g:rnvimr_ranger_cmd) 
    nmap <silent> <leader>e :RnvimrToggle<CR>
else
    nmap <silent> <leader>e <NOP>
endif
