call plug#begin('~/.vim/plugged')
" Plugins go here
Plug 'vim-scripts/kwbdi.vim'

" --- Making Vim look good ---
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" --- Programmer editor ---
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'janko-m/vim-test'
Plug 'anyakichi/vim-surround'
Plug 'editorconfig/editorconfig-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'

" --- Frontend
Plug 'ap/vim-css-color'

" --- JavaScript
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'javascript.jsx','typescript'],
  \ 'do': 'make install'
\ }

" --- Go
Plug 'fatih/vim-go'

call plug#end()

