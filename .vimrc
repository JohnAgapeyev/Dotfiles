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
Plug 'neomake/neomake'
Plug 'junegunn/fzf'
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

" Track the engine.
Plug 'SirVer/ultisnips'
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

if has('nvim')
    " Use deoplete.
    let g:deoplete#enable_at_startup = 1
    "dont require the same file type
    let g:deoplete#buffer#require_same_filetype = 0
    "
endif

"Set proper python paths
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

"ULTISNIPS
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/customsnippets']
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-space>"
let g:UltiSnipsJumpForwardTrigger="<c-l>"
let g:UltiSnipsJumpBackwardTrigger="<c-h>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"NEOMAKE
" When writing a buffer (no delay).
call neomake#configure#automake('w')

let g:neomake_c_enabled_makers=['gcc']
let g:neomake_cpp_enabled_makers=['gcc']

let g:neomake_c_gcc_args=[
            \ '-std=c11',
            \ '-Wall',
            \ '-Wextra',
            \ '-Wpedantic',
            \ '-Wformat=2',
            \ '-Wuninitialized',
            \ '-Wundef',
            \ '-Wfloat-equal',
            \ '-Wshadow',
            \ '-Wcast-align',
            \ '-Wstrict-prototypes',
            \ '-Wstrict-overflow=2',
            \ '-Wwrite-strings',
            \ '-fopenmp',
            \ ]
let g:neomake_cpp_gcc_args=[
            \ '-std=c++17',
            \ '-Wall',
            \ '-Wextra',
            \ '-Wpedantic',
            \ '-Wformat=2',
            \ '-Wuninitialized',
            \ '-Wundef',
            \ '-Wfloat-equal',
            \ '-Wshadow',
            \ '-Wcast-align',
            \ '-Wstrict-prototypes',
            \ '-Wstrict-overflow=2',
            \ '-Wwrite-strings',
            \ '-fopenmp',
            \ ]
"
"END NEOMAKE

"[fzf]
map <C-m> :FZF<CR>
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" The Silver Searcher
if executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
    set grepprg=ag\ --nogroup\ --nocolor
endif

" ripgrep
if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
    set grepprg=rg\ --vimgrep
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

"tab nav with shift
nnoremap H gT
nnoremap L gt
"tab management with t leader
nnoremap tn :tabnew<CR>
nnoremap tq :tabclose<CR>

" Run this command daily using vim-update-daily plugin
let g:update_daily = 'PlugUpdate --sync | PlugUpgrade | PlugClean | q'

"Set the colorscheme and gruvbox contrast
colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_italic = 1

"Enable nerdtree on launch and restore focus to file window
autocmd StdinReadPre * let s:std_in=1
autocmd vimenter * NERDTree | wincmd p
autocmd TabEnter * NERDTreeFocus | NERDTreeMirror | wincmd p
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>

"Strip trailing whitespace on save
autocmd BufEnter * EnableStripWhitespaceOnSave

"Close preview window after insertion completion
autocmd CompleteDone * pclose

"Jump to last open
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"AIRLINE
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
"END AIRLINE

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
