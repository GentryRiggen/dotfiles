call plug#begin('~/.vim/plugged')
 
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'chriskempson/vim-tomorrow-theme'

" Add plugins to &runtimepath
call plug#end()

" Fuzzy Search
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Airline
let g:airline#extensions#tabline#enabled = 1

" THEME
syntax on
colorscheme Tomorrow-Night-Eighties
let g:airline_theme='simple'

" NERD TREE toggle
map <C-n> :NERDTreeToggle<CR>

set number

" Whitespace characters
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set tabstop=4
set listchars=tab:>-,trail:-
set list
