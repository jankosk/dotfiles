inoremap jk <ESC>

let mapleader = ","

syntax on
filetype plugin indent on

set ruler

set visualbell

set number 

set noswapfile

set encoding=utf-8

set ttyfast

set laststatus=2

" Whitespace
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set shiftround
set autoindent
set smartindent

" Search
set hlsearch
set ignorecase
set incsearch 
" clear search
map <leader><space> :let @/=''<cr>

set t_Co=256
set background=dark

nnoremap gh g^
nnoremap gl g_

" Copy to clipboard
set clipboard=unnamed

