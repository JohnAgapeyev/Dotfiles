set nocompatible              " be iMproved, required

let s:vim_plug = '~/.local/share/nvim/site/autoload/plug.vim'
if empty(glob(s:vim_plug, 1))
  execute 'silent !curl -fLo' s:vim_plug '--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin()
Plug 'junegunn/vim-plug'
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'vim-airline/vim-airline'
Plug 'ntpeters/vim-better-whitespace'
Plug 'skywind3000/asyncrun.vim'
Plug 'isaacmorneau/vim-update-daily'
call plug#end()

if has('nvim')
    "check if we need to install any missing plugins
    let s:need_install = join(keys(filter(copy(g:plugs), '!isdirectory(v:val.dir)')), ' ')
    if len(s:need_install)
        "This needs to be called seperately in order for plugins to load correctly after installation
        execute 'autocmd VimEnter * PlugInstall --sync' s:need_install '| source $MYVIMRC'
    endif

    " Run this command daily using vim-update-daily plugin
    let g:update_daily = 'PlugUpdate | PlugUpgrade'

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

autocmd BufEnter * EnableStripWhitespaceOnSave

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

