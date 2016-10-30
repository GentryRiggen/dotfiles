" give me a home variable to work with
let $VIMHOME = $HOME."/.vim"

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'scrooloose/syntastic'
Plug 'ervandew/supertab'
Plug 'sheerun/vim-polyglot'

" Add plugins to &runtimepath
call plug#end()

" change backup dir
set backupdir=$VIMHOME/backup
set directory=$VIMHOME/backup

" Fuzzy Search
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Airline
let g:airline#extensions#tabline#enabled = 1

" THEME
syntax on
colorscheme Tomorrow-Night-Bright
let g:airline_theme='simple'

" NERD TREE toggle
map <C-n> :NERDTreeToggle<CR>

" Line numbers
set number

" Whitespace characters
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set tabstop=4
set listchars=nbsp:☠,tab:▸-,trail:~,extends:>,precedes:<,space:.
set list

" Clipboard shared
set clipboard=unnamed

" per language tabbing
augroup language_tabbing
  autocmd!
  autocmd Filetype php        setlocal ts=4 sts=4 sw=4 noexpandtab
  autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 expandtab
  autocmd Filetype scss       setlocal ts=2 sts=2 sw=2 expandtab
  autocmd Filetype css        setlocal ts=2 sts=2 sw=2 expandtab
  autocmd Filetype ruby       setlocal ts=2 sts=2 sw=2 expandtab
  autocmd Filetype html       setlocal ts=2 sts=2 sw=2 expandtab
  autocmd Filetype coffee     setlocal foldmethod=indent nofoldenable
augroup END

" Cursor
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Eslint Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_jsx_checkers = ['eslint']
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']

" map leader to comma for speed!!!
let mapleader=","

" choose buffer faster
map <leader>s :bnext<CR>
map <leader>a :bprev<CR>
map <leader>bd :bdel<CR>
