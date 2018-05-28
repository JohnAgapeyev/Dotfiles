set nocompatible              " be iMproved, required

"Silently download and install vim-plug
let s:vim_plug = '~/.vim/autoload/plug.vim'
if empty(glob(s:vim_plug, 1))
    execute 'silent !curl -fLo' s:vim_plug '--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'junegunn/vim-plug'
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-clang'
    Plug 'Shougo/neoinclude.vim'
else
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'vim-airline/vim-airline'
Plug 'ntpeters/vim-better-whitespace'
Plug 'isaacmorneau/vim-update-daily'
call plug#end()

"Autoinstall plugins
autocmd VimEnter *
            \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \|   PlugInstall --sync | q
            \| endif

if has('nvim')
    " Run this command daily using vim-update-daily plugin
    let g:update_daily = 'PlugUpdate --sync | PlugUpgrade | PlugClean | q'

    " Use deoplete.
    let g:deoplete#enable_at_startup = 1
endif

"Set the colorscheme and gruvbox contrast
colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"

"Enable nerdtree on launch and restore focus to file window
autocmd StdinReadPre * let s:std_in=1
autocmd vimenter * NERDTree | wincmd p
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"Strip trailing whitespace on save
autocmd BufEnter * EnableStripWhitespaceOnSave

"Close preview window after insertion completion
autocmd CompleteDone * pclose

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

set t_Co=256

set background=dark

set number

set autoread

set ruler

set cmdheight=2
set showcmd

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

set encoding=utf8

set ffs=unix,dos,mac

set nobackup
set nowb
set noswapfile

set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

filetype indent plugin on

set lbr
set tw=500

set ai
set si
set wrap

set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds

set mouse=a
set confirm

set backspace=indent,eol,start

set wildmenu

