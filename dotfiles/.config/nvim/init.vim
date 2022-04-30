" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath=&runtimepath
" source ~/.vimrc

lua <<EOF
-- Use to debug
-- vim.lsp.set_log_level("debug")
EOF

" Require ~/.config/nvim/lua/init.lua
lua require "init"

" Italic support
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
