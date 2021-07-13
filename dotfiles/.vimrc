source $HOME/.config/vim/plugins.vim
source $HOME/.config/vim/options.vim
source $HOME/.config/vim/keymappings.vim

" --- Plugins Config ---
source $HOME/.config/vim/config/fzf-config.vim
source $HOME/.config/vim/config/nerdtree-config.vim

" --- Javascript
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1

" --- Airline
let g:airline_theme = 'onedark'
" let g:airline_theme='luna'
let g:airline_powerline_fonts = 1
" enable tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#scrollbar#enabled = 0

" --- Gitgutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = 'o'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = 'w'

" --- JSDocs
let g:jsdoc_enable_es6 = 1
let g:jsdoc_underscore_private = 1
let g:jsdoc_access_descriptions = 2

" --- Go ---
let g:go_def_mapping_enabled = 0

" --- Files config
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
autocmd Filetype go setlocal ts=4 sw=4 noexpandtab foldmethod=marker foldmarker={,}
autocmd Filetype javascript setlocal ts=2 sw=2 expandtab foldmethod=syntax
autocmd Filetype javascript.jsx setlocal ts=2 sw=2 expandtab foldmethod=syntax

"  Terminal Stuff
augroup terminal_stuff
    autocmd!
    if v:progname == "nvim"
        autocmd TermOpen * setlocal nonumber norelativenumber
    endif
augroup END
