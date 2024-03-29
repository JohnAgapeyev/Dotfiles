"Redundant for Neovim
set nocompatible

"Silently download and install vim-plug
let s:vim_plug = '~/.vim/autoload/plug.vim'
if empty(glob(s:vim_plug, 1))
    execute 'silent !curl -fLo' s:vim_plug '--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"[polyglot]
"Plugin is good but the indentation detection is horribly fucked
"Needs to be put before loading polyglot
let g:polyglot_disabled = ['autoindent']

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
Plug 'tpope/vim-surround'
Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'luochen1990/rainbow'
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
                call mkdir(directory, "p")
            endif
        endif
        let directory = substitute(directory, " ", "\\\\ ", "g")
        exec "set " . settingname . "=" . directory
    endfor
    let g:scratch_dir = common_dir . 'scratch'. '/'
    if exists("*mkdir")
        if !isdirectory(g:scratch_dir)
            call mkdir(g:scratch_dir, "p")
        endif
    endif
    let cache_dir = common_dir . 'tags'. '/'
    if exists("*mkdir")
        if !isdirectory(cache_dir)
            call mkdir(cache_dir, "p")
        endif
    endif
endfunction
call InitializeDirectories()

function MoveToPrevTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() != 1
        close!
        if l:tab_nr == tabpagenr('$')
            tabprev
        endif
        sp
    else
        close!
        exe "0tabnew"
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
endfunc

function MoveToNextTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() < tab_nr
        close!
        if l:tab_nr == tabpagenr('$')
            tabnext
        endif
        sp
    else
        close!
        tabnew
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
endfunc

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

"100 char line highlight
set colorcolumn=100

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
"Do not store hidden and unloaded buffers
set ssop-=buffers
"Do not store the help window
set ssop-=help

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
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
else
    set clipboard=unnamed
endif

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

"Let's ignore tons of garbage/binary/random files
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
set wildignore+=*/obj/*
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

"Open the filename under cursor as a new window
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

"[Window management]
"Ctrl-W is stupid, just rebind it to Alt instead
"Benefit is that Alt can be held for multiple ops
"Basic movement
nnoremap <A-h> <C-W>h
nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-l> <C-W>l
"Window movement
nnoremap <A-H> <C-W>H
nnoremap <A-J> <C-W>J
nnoremap <A-K> <C-W>K
nnoremap <A-L> <C-W>L
nnoremap <A-.> :call MoveToNextTab()<CR>
nnoremap <A-,> :call MoveToPrevTab()<CR>
"New window creation
nnoremap <A-n> :vnew<CR>
nnoremap <A-s> <C-W>s
nnoremap <A-v> <C-W>v
"Quit the current window
nnoremap <A-q> <C-W>q
"Resizing
nnoremap <A--> <C-W>-
nnoremap <A-+> <C-W>+
nnoremap <A-<> <C-W><
nnoremap <A->> <C-W>>
nnoremap <A-=> <C-W>=
nnoremap <A-_> <C-W>_

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

"S and cc are duplicates so mimic the inverse of J for S
nnoremap S :keeppatterns substitute/\s*\%#\s*/\r/e <bar> normal! ==<CR>

"extend * and # to visual mode
"found from /u/noahspurrier
vmap <silent> * y:let @/=substitute(escape(@",'.$*[^\/~'),'\n','\\n','g')<CR>n
vmap <silent> # y:let @/=substitute(escape(@",'.$*[^\/~'),'\n','\\n','g')<CR>N
vnoremap <silent> * :<C-U>
              \let old_reg=getreg('"')<bar>
              \let old_regmode=getregtype('"')<cr>
              \gvy/<C-R><C-R>=substitute(substitute(
              \escape(@", '\\/.*$^~[]' ), "\n$", "", ""),
              \"\n", '\\_[[:return:]]', "g")<cr><cr>
              \:call setreg('"', old_reg, old_regmode)<cr>
vnoremap <silent> # :<C-U>
              \let old_reg=getreg('"')<bar>
              \let old_regmode=getregtype('"')<cr>
              \gvy?<C-R><C-R>=substitute(substitute(
              \escape(@", '\\/.*$^~[]' ), "\n$", "", ""),
              \"\n", '\\_[[:return:]]', "g")<cr><cr>
              \:call setreg('"', old_reg, old_regmode)<cr>

"[AUTOCMDS]
"Jump to last open
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"Close preview window after insertion completion
autocmd CompleteDone * pclose

"[TAGS]
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
nnoremap <Leader>] :execute 'tj' expand('<cword>')<CR>
"Find functions calling the current word under the cursor
nnoremap <Leader>\ :call FindSymbol()<CR>

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

let ctags_callbacks = {
            \ 'on_exit': function('CtagsExit')
            \ }

let cscope_callbacks = {
            \ 'on_exit': function('CscopeExit')
            \ }

function! GenMetadata()
    :silent !mkdir -p /tmp/custom_vimrc/
    :silent !find $PWD -path "*bin*" -prune -o -path "*CMakeFiles*" -prune -o -path "*venv*" -prune -o -type f -regex ".*\.\(c\|h\)\(pp\)*$" -exec readlink -f {} + > /tmp/custom_vimrc/tags_files
if has("nvim")
    call jobstart('rm tags; ctags -L /tmp/custom_vimrc/tags_files', g:ctags_callbacks)
    call jobstart('cscope -bq -i /tmp/custom_vimrc/tags_files', g:cscope_callbacks)
else
    :!rm tags; ctags -L /tmp/custom_vimrc/tags_files
    :!cscope -bq -i /tmp/custom_vimrc/tags_files <Bar> :cscope reset
endif
endfunction

"Regenerate tags and cscope files
nnoremap <Leader>b :call GenMetadata()<CR>

if filereadable("cscope.out")
    :silent execute "normal :cscope add .\<CR>"
endif

"[PLUGIN CONFIG]

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
nnoremap <CR> :FZF<CR>

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
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-s': 'split' }

" Run this command daily using vim-update-daily plugin
let g:update_daily = 'PlugUpdate --sync | PlugUpgrade | PlugClean | q'
let g:update_noargs = 1

"Enable nerdtree on launch and restore focus to file window
"autocmd StdinReadPre * let s:std_in=1
"autocmd vimenter * NERDTree | wincmd p
"autocmd TabEnter * NERDTreeFocus | NERDTreeMirror | wincmd p
autocmd BufEnter * nested if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nnoremap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeShowHidden=1

"Strip trailing whitespace on save
autocmd BufEnter * EnableStripWhitespaceOnSave

"[airline]
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

"[rainbow]
"Enable rainbow braces
let g:rainbow_active = 1

"[gitgutter]
"these are so that gitgutter gives more snappy updates when doing lots of
"editing by rechecking on anything to do with insert
autocmd InsertLeave * nested call gitgutter#process_buffer(bufnr(''), 0)
autocmd InsertEnter * nested call gitgutter#process_buffer(bufnr(''), 0)

command! -complete=shellcmd -nargs=+ Sh call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
    echo a:cmdline
    let expanded_cmdline = a:cmdline
    for part in split(a:cmdline, ' ')
        if part[0] =~ '\v[%#<]'
            let expanded_part = fnameescape(expand(part))
            let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
        endif
    endfor
    botright new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    call setline(1, 'cmd: ' .expanded_cmdline)
    call setline(2,substitute(getline(1),'.','=','g'))
    execute '$read !'. expanded_cmdline
    setlocal nomodifiable
    1
endfunction
