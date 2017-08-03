set nocompatible              " be iMproved, required

call plug#begin()
Plug 'junegunn/vim-plug'
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'Shougo/deoplete.nvim'
Plug 'vim-airline/vim-airline'
call plug#end()

if has('nvim')
    "check if we need an upgrade or an update
    command! PU PlugUpgrade | PlugUpdate
    let s:need_install = keys(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
    let s:need_clean = len(s:need_install) + len(globpath(g:plug_home, '*', 0, 1)) > len(filter(values(g:plugs), 'stridx(v:val.dir, g:plug_home) == 0'))
    let s:need_install = join(s:need_install, ' ')
    if has('vim_starting')
        if s:need_clean
            autocmd VimEnter * PlugClean!
        endif
        if len(s:need_install)
            execute 'autocmd VimEnter * PlugInstall --sync' s:need_install '| source $MYVIMRC'
            finish
        endif
    else
        if s:need_clean
            PlugClean!
        endif
        if len(s:need_install)
            execute 'PlugInstall --sync' s:need_install | source $MYVIMRC
            finish
        endif
    endif

    " Use deoplete.
    let g:deoplete#enable_at_startup = 1
endif

"Set the colorscheme and gruvbox contrast
colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"

"Enable nerdtree on launch and restore focus to file window
autocmd StdinReadPre * let s:std_in=1
autocmd vimenter * NERDTree | wincmd p
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

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

