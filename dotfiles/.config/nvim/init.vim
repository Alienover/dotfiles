" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath=&runtimepath
" source ~/.vimrc

lua <<EOF
-- Use to debug
-- vim.lsp.set_log_level("debug")
EOF

" Require ~/.config/nvim/lua/init.lua
lua require "init"

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Disable the cursorline to remove the annoying underling
augroup diff_cursor
    autocmd BufEnter * if &diff | setlocal nocursorline | endif
augroup END

" Remove the editor styling for terminal
augroup terminal
    autocmd!
    if v:progname == "nvim"
	autocmd TermOpen * setlocal nonumber norelativenumber
    endif
augroup END


" Show cursor line only in active window
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" Highlight on yank
autocmd TextYankPost * lua vim.highlight.on_yank {}

" Windows to close with <q>
autocmd FileType help,startuptime,qf,lspinfo nnoremap <buffer><silent> q :close<CR>
autocmd FileType man nnoremap <buffer><silent> q :quit<CR>

lua << EOF
    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.typescript.used_by = "javascript.jsx"
EOF
