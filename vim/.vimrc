set history=1000
filetype plugin on
syntax on
set autoread
let mapleader=" "
let g:mapleader = " "
let maplocalleader = ","
let g:maplocalleader = ","

" save with <SPACE>w
nmap <leader>w :w!<cr>

" quit with <SPACE>q
nmap <leader>q :q!<cr>

command W w !sudo tee % > /dev/null

" Ignore case when searching
set ignorecase

" smart searching
set smartcase

" highlight search
set hlsearch

" search like browsers
set incsearch
" match brackets 
set showmatch

filetype indent on

set tabstop=4
set shiftwidth=4
set expandtab
set modeline
set relativenumber
set backspace=indent,eol,start

set ruler
set breakindent
set showbreak=\\\\\

set wildmenu
set wildmode=full

set foldmethod=indent
set foldnestmax=2
set nofoldenable

set nobackup
set nowb
set noswapfile

" last opened position
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") | 
	\ 	exe "normal! g`\"" | 
	\ endif

set clipboard=unnamedplus
setlocal fo+=aw

:imap jj <Esc>

""""""""""""""
"  Filetype  "
""""""""""""""
au FileType mail setlocal sw=2 sts=2 textwidth=0 wrapmargin=0 wrap linebreak nolist
au FileType vimwiki  setlocal tabstop=2 shiftwidth=2 expandtab
au FileType javascript  setlocal tabstop=2 shiftwidth=2 expandtab
au FileType svelte  setlocal tabstop=2 shiftwidth=2 expandtab
au FileType json  setlocal tabstop=2 shiftwidth=2 expandtab
au FileType typescript  setlocal tabstop=2 shiftwidth=2 expandtab
au FileType markdown  setlocal tabstop=2 shiftwidth=2 expandtab
au FileType text  setlocal tabstop=2 shiftwidth=2 expandtab
au FileType html  setlocal tabstop=2 shiftwidth=2 expandtab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Set local language (en_us, pt_br)
nmap <Leader>se :setlocal spell! spelllang=en_us<CR>
nmap <Leader>sb :setlocal spell! spelllang=pt_br<CR>

" Automatically correct spell with first suggestion
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
au FileType yaml  setlocal tabstop=2 shiftwidth=2 expandtab

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => OPEN
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <Leader>ot :e ~/todo.txt<CR>
nmap <Leader>oc :e ~/.dotfiles/vim/.vimrc<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Theme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
syntax enable
