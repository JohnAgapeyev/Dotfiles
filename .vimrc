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
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'ntpeters/vim-better-whitespace'
Plug 'isaacmorneau/vim-update-daily'
Plug 'sheerun/vim-polyglot'
Plug 'chrisbra/Colorizer'
Plug 'sbdchd/neoformat'
Plug 'isaacmorneau/vim-simple-sessions'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-surround'
Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment'
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
    let g:gutentags_cache_dir = common_dir . 'tags'. '/'
    if exists("*mkdir")
        if !isdirectory(g:gutentags_cache_dir)
            call mkdir(g:gutentags_cache_dir)
        endif
    endif
    if !isdirectory(g:gutentags_cache_dir)
        echo "Warning: Unable to create tags directory: " . g:gutentags_cache_dir
        echo "Try: mkdir -p " . g:gutentags_cache_dir
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

"Set the colorscheme and gruvbox contrast
colorscheme gruvbox
let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_italic = 1

"[GENERAL SETTINGS]

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

"Unload buffers that are no longer in use
set nohidden

"Show the current command
set showcmd

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
set fileencoding=utf-8
set fileencodings=utf-8

"LF is the only acceptable line ending
set ffs=unix,dos,mac

"Tabs are 4 spaces
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

"Enable auto and smart indent
set autoindent
set smartindent

"When in Rome...
set copyindent

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
set clipboard+=unnamedplus

"enable true 24-bit colour
set tgc

"Set shell to bash
if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/bash
endif

"Update things after 1 second being idle
set updatetime=1000

"Leader as space, since \ is awkward
let mapleader = ' '

"This is gross, but it lets me do stuff like "gf" to open the file under the cursor
set path=**

"New splits go on the right, I'm not an animal
set splitright


"[BINDINGS]
"Tab nav with shift
nnoremap H gT
nnoremap L gt
"Tab move with Ctrl
nnoremap <C-h> :tabmove -1<CR>
nnoremap <C-l> :tabmove +1<CR>
"Tab management with t leader
"Open new tab at end of tab list
nnoremap tn :$tabnew<CR>
"Close the current tab
nnoremap tq :tabclose<CR>
"Open the filename under cursor at end of tab list
nnoremap tf <C-w>gf<CR>:tabmove<CR>

"Open the filename under cursor at end of tab list
nnoremap <Leader>f <C-w><C-f><C-w>L

"Automatically split multiple files given via command line into their own tabs
if !&diff && argc() > 1
	autocmd VimEnter * nested :execute 'silent argdo :tab split' | tabclose
endif

"Move on visual lines, not on wrapped/real ones
nnoremap j gj
nnoremap k gk
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>

"when the window gets resized reset the splits
autocmd VimResized * wincmd =

"i never want the help page! i always wanted ESC
nnoremap <F1> <ESC>
inoremap <F1> <ESC>

"how dare you not use regex by default
nnoremap / /\v
vnoremap / /\v

"keep visual selection after shift
vnoremap < <gv
vnoremap > >gv

"Re-select our last pasted block
nnoremap gp `[v`]

"We're not in the 1970's, ex is not a better ed, disable ex mode
nnoremap Q <nop>

" allow the . to execute once for each line of a visual selection
vnoremap . :normal! .<CR>

"Allows a macro to easily be executed on every line of a visual selection
vnoremap @ :'<,'>norm! @

"[AUTOCMDS]
"Jump to last open
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"Close preview window after insertion completion
autocmd CompleteDone * pclose

"[TAGS]
function! CtagsExit(job_id, data, event) dict
    echo "CTags generation complete"
endfunction

function! CscopeExit(job_id, data, event) dict
    echo "Cscope generation complete"
    try
        :cscope add .
        :cscope reset
    catch /^Vim\%((\a\+)\)\=:E/
        :cscope reset
    endtry
endfunction

"Tries to find functions calling the current function
"but will fallback to all usages if that fails
"This is mainly for handling functions and variables/types with the same
"command
function! FindSymbol()
    try
        :cscope find c <cword>
    catch /^Vim\%((\a\+)\)\=:E/
        :cscope find s <cword>
    endtry
endfunction

"Go back one level up the tag stack
nnoremap <Leader>[ :pop<CR>
"Search for tag using regexp, jump if only one, otherwise, list options
nnoremap <Leader>/ :tj<Space>/

"Search for tag using regexp, jump if only one, otherwise, list options
nnoremap <Leader>] :execute 'tag' expand('<cword>')<CR>
"Find functions calling the current word under the cursor
nnoremap <Leader>\ :call FindSymbol()<CR>

"[PLUGIN CONFIG]

"[Gutentags]
let g:gutentags_modules = ['ctags', 'cscope', 'gtags_cscope']
let g:gutentags_add_default_project_roots = 1

let g:gutentags_exclude_project_root = ['/usr/local', $HOME]

let g:gutentags_cscope_build_inverted_index = 1

set statusline+=%{gutentags#statusline()}

"[Neoformat]
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
nnoremap <C-m> :FZF<CR>
set wildmode=list:longest,list:full
set wildignore+=*.o
set wildignore+=*.d
set wildignore+=*.obj
set wildignore+=*.git
set wildignore+=*.rbc
set wildignore+=*.pyc
set wildignore+=__pycache__
set wildignore+=*.exe
set wildignore+=*.elf
set wildignore+=cscope.*
set wildignore+=tags*
set wildignore+=*.svn
set wildignore+=*.hg
set wildignore+=build
set wildignore+=dist
set wildignore+=*sites/*/files/*
set wildignore+=bin
set wildignore+=node_modules
set wildignore+=bower_components
set wildignore+=cache
set wildignore+=compiled
set wildignore+=docs
set wildignore+=example
set wildignore+=bundle
set wildignore+=vendor
set wildignore+=*.md
set wildignore+=*-lock.json
set wildignore+=*.lock
set wildignore+=*bundle*.js
set wildignore+=*build*.js
set wildignore+=.*rc*
set wildignore+=*.json
set wildignore+=*.min.*
set wildignore+=*.map
set wildignore+=*.bak
set wildignore+=*.zip
set wildignore+=*.pyc
set wildignore+=*.class
set wildignore+=*.sln
set wildignore+=*.Master
set wildignore+=*.csproj
set wildignore+=*.tmp
set wildignore+=*.csproj.user
set wildignore+=*.cache
set wildignore+=*.pdb
set wildignore+=*.css
set wildignore+=*.less
set wildignore+=*.scss
set wildignore+=*.dll
set wildignore+=*.mp3
set wildignore+=*.ogg
set wildignore+=*.flac
set wildignore+=*.swp
set wildignore+=*.swo
set wildignore+=*.bmp
set wildignore+=*.gif
set wildignore+=*.ico
set wildignore+=*.jpg
set wildignore+=*.png
set wildignore+=*.rar
set wildignore+=*.zip
set wildignore+=*.tar
set wildignore+=*.tar.*
set wildignore+=*.pdf
set wildignore+=*.doc
set wildignore+=*.docx
set wildignore+=*.ppt
set wildignore+=*.pptx

let $FZF_DEFAULT_COMMAND =  "find . -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --no-ignore --glob "!.git/*"'
    set grepprg=rg\ --vimgrep
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

"match current color scheme
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_action = {
  \ 'ctrl-t': '$tab split',
  \ 'ctrl-v': 'vsplit' }

" Run this command daily using vim-update-daily plugin
let g:update_daily = 'PlugUpdate --sync | PlugUpgrade | PlugClean | q'
let g:update_noargs = 1

"Enable nerdtree on launch and restore focus to file window
autocmd StdinReadPre * let s:std_in=1
"autocmd vimenter * NERDTree | wincmd p
"autocmd TabEnter * NERDTreeFocus | NERDTreeMirror | wincmd p
autocmd BufEnter * nested if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nnoremap <C-n> :NERDTreeToggle<CR>

"Strip trailing whitespace on save
autocmd BufEnter * EnableStripWhitespaceOnSave

"[airline]
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

"[gitgutter]
"these are so that gitgutter gives more snappy updates when doing lots of
"editing by rechecking on anything to do with insert
autocmd InsertLeave * nested call gitgutter#process_buffer(bufnr(''), 0)
autocmd InsertEnter * nested call gitgutter#process_buffer(bufnr(''), 0)
