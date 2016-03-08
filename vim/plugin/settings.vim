" Insert Cursor
let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q"

" Line Numbers
set number

" Whitespace characters
set listchars=tab:>·,trail:~,extends:>,precedes:<,space:␣
set list

"Clipboard
set clipboard=unnamed

"Syntax highlighting
syntax enable

" Status Line
set laststatus=2

" Specific Language tabbing
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

" Airline settings
let g:airline#extensions#whitespace#enabled=0
let g:airline_left_sep=''
let g:airline_right_sep=''

" Color scheme
colorscheme Tomorrow-Night-Bright
