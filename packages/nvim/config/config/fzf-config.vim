
" --- If installed using Homebrew
set rtp+=/usr/local/opt/fzf
let $FZF_DEFAULT_OPTS="--color fg:242,bg:236,hl:114,fg+:15,bg+:236,hl+:114,info:108,prompt:109,spinner:108,pointer:114,marker:173 --layout=reverse --margin=1,2"

"  Default fzf layout
let g:fzf_layout = { 'window': 'call OpenFloatingWin()' }

" Base function to open floating window
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
    tnoremap <buffer> <silent> <Esc> <C-\><C-n>:q<CR>
endfunction

" -------------------------------
" FZF - Files
" -------------------------------
function! FzfFiles()
    let source = "find * -path '*/\.*' -prune -o -path 'node_modules' -prune -o -path '**/node_modules' -prune -o -path 'target/**' -prune -o -path 'dist' -prune -o -path '**/dist' -prune -o  -type f -print -o -type l -print 2> /dev/null"
    let options = $FZF_DEFAULT_OPTS . " " . "--preview 'if file -i {}|grep -q binary; then file -b {}; else bat --style=changes --color always --line-range :40 {}; fi' --preview-window bottom"

    call fzf#run(fzf#wrap({
                \ 'source': source,
                \ 'options': options,
                \}))
endfunction
nnoremap <silent> <C-P> :call FzfFiles()<CR>

" -------------------------------
" FZF - Folders
" -------------------------------
function! FzfFolders()
    let source = "find * -path '*/\.*' -prune -o -path 'target/**' -prune -o -path 'dist' -print -o -path '**/dict' -prune -o -type d -print -o -type l -print 2> /dev/null"
    let sink = "NERDTree"
    let options = $FZF_DEFAULT_OPTS . " " . "--preview 'tree -L 1 -C {}' --preview-window bottom"
    call fzf#run(fzf#wrap({
                \ 'source': source,
                \ 'options': options,
                \ 'sink': sink,
                \ }))
endfunction

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

function! FzfBuffers()
    let source = s:buflist()
    let options = $FZF_DEFAULT_OPTS . ' ' . '--prompt "Buffers > " --no-preview'
    call fzf#run(fzf#wrap({
                \ 'source': source,
                \ 'options': options,
                \ 'sink': function("s:jump_buffer"),
                \ 'window': "call OpenFloatingWin(10, 80)"
                \ }))
endfunction


" -------------------------------
" FZF - Tmux Sessions
" -------------------------------
function! FzfTmuxSessions()
    let source = 'tmux list-sessions -F "#S: #{session_windows} windows #{?session_attached,(attached),}"'
    let options = $FZF_DEFAULT_OPTS . ' ' . '--prompt "Project: > " --preview "tmux capture-pane -p -E 10 -t {+1}" --preview-window bottom --print-query'
    call fzf#run(fzf#wrap({
                \ 'source': source,
                \ 'options': options,
                \ 'sink': "!sh $HOME/.tmux_settings/tmux_switchy.sh ",
                \ 'window': "call OpenFloatingWin(20, 80)"
                \ }))
endfunction
