set nocompatible              " be iMproved, required
filetype off                  " required
set t_Co=256

set background=dark
syntax on

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'morhetz/gruvbox'

Plugin 'scrooloose/nerdtree'

Plugin 'tpope/vim-fugitive'

Plugin 'scrooloose/syntastic'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"Set the colorscheme and gruvbox contrast
colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"

"Enable nerdtree on launch and restore focus to file window
autocmd StdinReadPre * let s:std_in=1
autocmd vimenter * NERDTree | wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

set number

set autoread

set ruler

set cmdheight=2

set hid

set ignorecase

set smartcase

set hlsearch

set incsearch

set lazyredraw

set magic

set showmatch

set noerrorbells
set novisualbell
set t_vb=
set tm=500

set foldcolumn=1

set background=dark

set encoding=utf8

set ffs=unix,dos,mac

set nobackup
set nowb
set noswapfile
set expandtab

set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

set lbr
set tw=500

set ai
set si
set wrap

set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds
