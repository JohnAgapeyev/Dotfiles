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
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'vim-airline/vim-airline'
Plug 'ntpeters/vim-better-whitespace'
Plug 'isaacmorneau/vim-update-daily'
Plug 'sheerun/vim-polyglot'
Plug 'chrisbra/Colorizer'
Plug 'sbdchd/neoformat'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
Plug 'Valloric/YouCompleteMe', {'do': 'python3 install.py --clang-completer'}
call plug#end()

"Create directories if they don't exist
"This will also set the temp files be stored in those directories
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views':  'viewdir',
                \ 'swap':   'directory',
                \ 'undo':   'undodir' }

    let common_dir = parent . '/.' . prefix . '/'

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
    let g:scratch_dir = common_dir . 'scratch'. '/'
    if exists("*mkdir")
        if !isdirectory(g:scratch_dir)
            call mkdir(g:scratch_dir)
        endif
    endif
    if !isdirectory(g:scratch_dir)
        echo "Warning: Unable to create scratch directory: " . g:scratch_dir
        echo "Try: mkdir -p " . g:scratch_dir
    endif
endfunction
call InitializeDirectories()

"Autoinstall plugins
autocmd VimEnter *
            \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \|   PlugInstall --sync | q
            \| endif

"Set proper python paths
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion=["<tab>"]
let g:ycm_key_list_previous_completion=["<S-tab>"]

map <C-f> :Neoformat<CR>

let g:neoformat_basic_format_align = 1
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

let g:neoformat_c_clang_format = {
            \ 'exe': 'clang-format',
            \ 'args': ['-style=~/.clang-format'],
            \ }
let g:neoformat_cpp_clang_format = {
            \ 'exe': 'clang-format',
            \ 'args': ['-style=~/.clang-format'],
            \ }

let g:neoformat_enabled_c = ['clangformat']
let g:neoformat_enabled_cpp = ['clangformat']

"[fzf]
map <C-m> :FZF<CR>
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

"tab nav with shift
nnoremap H gT
nnoremap L gt
"tab management with t leader
nnoremap tn :tabnew<CR>
nnoremap tq :tabclose<CR>

" Run this command daily using vim-update-daily plugin
let g:update_daily = 'PlugUpdate --sync | PlugUpgrade | PlugClean | q'
let g:update_noargs = 1

"Set the colorscheme and gruvbox contrast
colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_italic = 1

"Enable nerdtree on launch and restore focus to file window
autocmd StdinReadPre * let s:std_in=1
autocmd vimenter * NERDTree | wincmd p
autocmd TabEnter * NERDTreeFocus | NERDTreeMirror | wincmd p
autocmd BufEnter * nested if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>

"Strip trailing whitespace on save
autocmd BufEnter * EnableStripWhitespaceOnSave

"Close preview window after insertion completion
autocmd CompleteDone * pclose

"Jump to last open
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"[airline]
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

"[gitgutter]
"these are so that gitgutter gives more snappy updates when doing lots of
"editing by rechecking on anything to do with insert
autocmd insertleave * nested call gitgutter#process_buffer(bufnr(''), 0)
autocmd insertenter * nested call gitgutter#process_buffer(bufnr(''), 0)

"Enable syntax highlighting
syntax on

"Set indent style from plugin
filetype indent plugin on

"Use a dark background
set background=dark

"Show absolute column numbers
set number

"Reread a file if Vim didn't touch it
set autoread

"Display cursor position in file
set ruler

"Number of lines in cmd height
set cmdheight=2

"Show the current command
set showcmd

"Hide a buffer when it is abandoned
set hid

"Enable list mode to show whitespace
set list

"Don't be so pedantic about case
set ignorecase
set smartcase

"Highlight all search matches
set hlsearch
"Search the incremental pattern, rather than when I press enter
set incsearch

"Don't repaint when executing macros
set lazyredraw

"Modern magic characters instead of vi legacy cruft
set magic

"Brief jump to matching brace if it's on screen
set showmatch

"No sounds or flashing lights, I'm not a child
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"Show open/close folds
set foldcolumn=1

"Use utf8 like a normal person
set encoding=utf8

"LF is the only acceptable line ending
set ffs=unix,dos,mac

"Tabs are 4 spaces
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

"Enable auto and smart indent
set ai
set si

"Enable line wrapping
set wrap

"Do not store global and local values in a session
set ssop-=options
"Do not store folds
set ssop-=folds

"Allow me to use the mouse on terminal vim
set mouse=a

"Ask me if I'm doing something dumb
set confirm

"Be smart about backspacing
set backspace=indent,eol,start

"Wildcard/enhanced menu mode
set wildmenu

"Save all mistakes and edits
set undofile
set undolevels=1000
set undoreload=10000

"visualize whitepsace
set listchars=tab:→→,trail:●,nbsp:○

"Set up scratch file saving
let g:scratch_persistence_file = g:scratch_dir . strftime("scratch_%Y-%m-%d")
let g:scratch_no_mappings = 1

"share vim and system clipboard
set clipboard+=unnamed

"enable true 24-bit colour
set tgc

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/bash
endif

set updatetime=1000
