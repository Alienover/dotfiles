"  Define prefix dictionary
let g:which_key_map = {}

let g:which_key_map['d'] = ['bd', 'Delete Buffer']
let g:which_key_map['s'] = [':split', "Split"]
let g:which_key_map['v'] = [':vsplit', "vSplit"]
let g:which_key_map['b'] = {
            \ 'name': '+buffers',
            \ 'd': ['bd', 'Delete'],
            \ 'f': ['bfirst', 'First'],
            \ 'l': ['blast', 'Last'],
            \ 'n': ['bnext', 'Next'],
            \ 'p': ['bprevious', 'Previous'],
            \ 'b': [':call FzfBuffers()', 'Buffers']
            \ }
let g:which_key_map['f'] = {
            \ 'name': '+folders',
            \ 'f': [':call FzfFolders()', 'Folders'],
            \ 'v': [':e ~/.vimrc', 'Open .vimrc'],
            \ 'z': [':e ~/.zshrc', 'Open .zshrc']
            \ }
let g:which_key_map['s'] = [':call FzfTmuxSessions()', 'Select tmux session']

" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Register which key map
call which_key#register('<Space>', "g:which_key_map")

