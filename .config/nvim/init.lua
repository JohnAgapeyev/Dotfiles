local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Defined here to initialize it early and reuse it in multiple places
-- This is the main list of globs to ignore files for, which is used for both wildignore
-- and for building out the FZF default command arguments with the same data
local ignoreglobs = {
    "*.o",
    "*.d",
    "*.obj",
    "*.git",
    "*.rbc",
    "*.pyc",
    "__pycache__/**",
    "*.exe",
    "*.elf",
    "cscope.*",
    "tags*",
    "*.svn",
    "*.hg",
    "**/build/**",
    "**/dist/**",
    "*sites/*/files/**",
    "**/obj/**",
    "**/bin/**",
    "**/target/**",
    "**/node_modules/**",
    "**/bower_components/**",
    "**/cache/**",
    "**/compiled/**",
    -- "**/docs/**",
    "**/example/**",
    "**/bundle/**",
    "**/vendor/**",
    "*.lock",
    "*bundle*.js",
    "*build*.js",
    "*.min.*",
    "*.map",
    "*.bak",
    "*.zip",
    "*.pyc",
    "*.class",
    "*.sln",
    "*.Master",
    "*.csproj",
    "*.tmp",
    "*.csproj.user",
    "*.cache",
    "*.pdb",
    "*.less",
    "*.scss",
    "*.dll",
    "*.mp3",
    "*.ogg",
    "*.flac",
    "*.swp",
    "*.swo",
    "*.bmp",
    "*.gif",
    "*.ico",
    "*.jpg",
    "*.png",
    "*.rar",
    "*.zip",
    "*.tar",
    "*.tar.*",
    "*.pdf",
    "*.doc",
    "*.docx",
    "*.ppt",
    "*.pptx",
    "venv/**",
    ".venv/**",
    ".mypy_cache/**",
    ".pytest_cache/**",
    ".ruff_cache/**",
}

require("lazy").setup(
    {
        {
            "scrooloose/nerdtree",
            init = function()
                --Enable nerdtree on launch and restore focus to file window
                --autocmd StdinReadPre * let s:std_in=1
                --autocmd vimenter * NERDTree | wincmd p
                --autocmd TabEnter * NERDTreeFocus | NERDTreeMirror | wincmd p
                vim.cmd([[
            autocmd BufEnter * nested if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
            ]])
                vim.keymap.set("n", "<C-n>", vim.cmd.NERDTreeToggle)
                vim.g.NERDTreeShowHidden = 1
            end,
        },
        {
            "airblade/vim-gitgutter",
            init = function()
                -- these are so that gitgutter gives more snappy updates when doing lots of
                -- editing by rechecking on anything to do with insert
                vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
                    command = "GitGutter",
                })
            end,
        },
        "junegunn/fzf",
        {
            "junegunn/fzf.vim",
            dependencies = {
                "junegunn/fzf",
            },
            init = function()
                vim.keymap.set("n", "<CR>", vim.cmd.FZF)

                -- Need to use ["ctrl-t"] instead of literally ctrl-t because the dict key has a
                -- special character that needs escaping
                vim.g.fzf_action = {
                    ["ctrl-t"] = "$tab split",
                    ["ctrl-v"] = "vsplit",
                    ["ctrl-s"] = "split",
                }

                -- match current color scheme
                vim.g.fzf_colors = {
                    fg = { "fg", "Normal" },
                    bg = { "bg", "Normal" },
                    hl = { "fg", "Comment" },
                    ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
                    ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
                    ["hl+"] = { "fg", "Statement" },
                    info = { "fg", "PreProc" },
                    border = { "fg", "Ignore" },
                    prompt = { "fg", "Conditional" },
                    pointer = { "fg", "Exception" },
                    marker = { "fg", "Keyword" },
                    spinner = { "fg", "Label" },
                    header = { "fg", "Comment" },
                }

                -- This whole chunk is to make the FZF searcher aware of my wildignore globs
                if vim.fn.executable("rg") == 1 then
                    local formatted_globs = {}
                    for i, glob in ipairs(ignoreglobs) do
                        formatted_globs[i] = " --glob !" .. tostring(glob)
                    end
                    -- Should be good, but this is the old version in case I need to revert
                    --vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --no-ignore --glob "!.git/*"'
                    vim.env.FZF_DEFAULT_COMMAND = "rg --files -uu " .. tostring(table.concat(formatted_globs, ""))
                else
                    local formatted_globs = {}
                    -- Lua is 1-indexed, not 0-indexed
                    local idx = 1
                    for i, glob in ipairs(ignoreglobs) do
                        -- Only use the globs that contain "**" which would indicate a recursive folder glob
                        if string.match(glob, "[*][*]") then
                            formatted_globs[idx] = " -path " .. tostring(glob) .. " -prune -o "
                            idx = idx + 1
                        end
                    end
                    -- Should be good, but this is the old version in case I need to revert
                    vim.env.FZF_DEFAULT_COMMAND =
                        "find . -path '*/\\.git/*' -prune -o -path '**/node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o -path '*bin/**' -prune -o -path '*__pycache__*' -prune -o -type f -print -o -type l -print 2> /dev/null"
                    -- This is good, but runs into "Argument list too long" errors, so I'm keeping the hardcoded version
                    --
                    --vim.env.FZF_DEFAULT_COMMAND = "find . " .. tostring(table.concat(formatted_globs, '')) .. " -type f -print -o -type l -print 2> /dev/null"
                    --vim.print(vim.env.FZF_DEFAULT_COMMAND)
                end

                vim.cmd([[
                if executable('rg')
                    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
                endif
            ]])
            end,
        },
        {
            "ntpeters/vim-better-whitespace",
            init = function()
                -- Enable stripping trailing whitespace on save
                vim.api.nvim_create_autocmd({ "BufEnter" }, {
                    command = "EnableStripWhitespaceOnSave",
                })
            end,
        },
        "sheerun/vim-polyglot",
        "chrisbra/Colorizer",
        "tpope/vim-surround",
        "kana/vim-textobj-user",
        {
            "Julian/vim-textobj-variable-segment",
            dependencies = {
                "kana/vim-textobj-user",
            },
        },
        {
            "luochen1990/rainbow",
            init = function()
                -- Enable rainbow braces
                vim.g.rainbow_active = 1
            end,
        },
        {
            "morhetz/gruvbox",
            -- Don't lazy load my main colorscheme
            lazy = false,
            -- Load this before any other plugins
            priority = 1000,
            init = function()
                vim.g.gruvbox_contrast_dark = "hard"
                vim.g.gruvbox_italic = 1
                vim.cmd.colorscheme("gruvbox")
            end,
        },
        {
            "vim-airline/vim-airline",
            init = function()
                -- Enable the list of buffers
                vim.g["airline#extensions#tabline#enabled"] = 1
                -- Show just the filename
                vim.g["airline#extensions#tabline#fnamemod"] = ":t"
                vim.g["airline#extensions#tabline#formatter"] = "unique_tail_improved"
            end,
        },
        --{
        --    "isaacmorneau/vim-update-daily",
        --        init = function()
        --        -- Run this command daily using vim-update-daily plugin
        --        vim.g.update_daily = 'PackerSync | q'
        --        vim.g.update_noargs = true
        --    end,
        --},
        --{
        --    "sbdchd/neoformat",
        --    init = function()
        --        vim.keymap.set('', '<C-f>', vim.cmd.Neoformat)

        --        vim.g.neoformat_basic_format_align = 1
        --        vim.g.neoformat_basic_format_retab = 1
        --        vim.g.neoformat_basic_format_trim = 1

        --        vim.g.neoformat_c_clang_format = {
        --             exe = 'clang-format',
        --             args = {'-style=~/.clang-format'},
        --         }
        --        vim.g.neoformat_cpp_clang_format = {
        --             exe = 'clang-format',
        --             args = {'-style=~/.clang-format'},
        --         }

        --        vim.g.neoformat_enabled_c = {'clangformat'}
        --        vim.g.neoformat_enabled_cpp = {'clangformat'}
        --    end,
        --},
        {
            "stevearc/conform.nvim",
            cmd = { "ConformInfo" },
            keys = {
                {
                    "<C-f>",
                    function()
                        require("conform").format({ async = true })
                    end,
                    mode = "",
                    desc = "Format buffer",
                },
            },
            -- This will provide type hinting with LuaLS
            --- @module "conform"
            --- @type conform.setupOpts
            opts = {
                default_format_opts = {
                    -- Better to use the LSP to keep relevant configs all in one place
                    lsp_format = "prefer",
                },
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "ruff", "black", "isort", stop_after_first = true },
                    rust = { "rustfmt", lsp_format = "fallback" },
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                },
                formatters = {
                    stylua = {
                        prepend_args = {
                            "--indent-type",
                            "Spaces",
                            "--indent-width",
                            "4",
                            "--line-endings",
                            "Unix",
                            "--quote-style",
                            "AutoPreferDouble",
                            "--sort-requires",
                        },
                    },
                },
            },
            init = function()
                vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
            end,
        },
        {
            "isaacmorneau/vim-simple-sessions",
            init = function()
                vim.g.ss_auto_enter = true
                vim.g.ss_auto_exit = false
                vim.g.ss_auto_alias = true
                vim.g.ss_dir = vim.fn.stdpath("data") .. "/session/"
                -- May need to fork or tweak or submit PR to make this work nicely
                vim.g.ss_open_with_args = false
            end,
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                local configs = require("nvim-treesitter.configs")

                configs.setup({
                    ensure_installed = {
                        "c",
                        "cpp",
                        "rust",
                        "lua",
                        "vim",
                        "vimdoc",
                        -- Treesitter Query Language
                        "query",
                        "javascript",
                        "typescript",
                        "html",
                        "css",
                        "sql",
                        "bash",
                        "csv",
                        "json",
                        "cmake",
                        "make",
                        "python",
                        "regex",
                        "toml",
                        "xml",
                        "yaml",
                    },
                    -- Allows async installs
                    sync_install = false,
                    -- Requires tree-sitter CLI tool installed for it to be enabled
                    auto_install = false,
                    -- Currently not a fan of the highlighting with gruvbox, need to refine it
                    highlight = { enable = false },
                    -- Indents are currently broken af at least for C++ that I tested
                    indent = { enable = false },
                })
            end,
        },
        {
            "neovim/nvim-lspconfig",
            config = function()
                -- Globally static LSP config
                vim.lsp.config('*', {
                     -- capabilities = {
                         -- offsetEncoding = {"utf-8", "utf-16"},
                         -- textDocument = {
                         --     semanticTokens = {
                         --         multilineTokenSupport = true,
                         --     }
                         -- }
                     -- },
                     root_markers = { '.git' },
                })

                -- Globally dynamic LSP config running once the LSP attaches
                vim.api.nvim_create_autocmd("LspAttach", {
                    callback = function(args)
                        -- vim.lsp.set_log_level(vim.log.levels.DEBUG)
                        local client = vim.lsp.get_client_by_id(args.data.client_id)
                        if client:supports_method("textDocument/implementation") then
                            -- Create a keymap for vim.lsp.buf.implementation
                        end
                        if client:supports_method("textDocument/completion") then
                            -- Enable auto-completion
                            -- vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
                        end
                        if client:supports_method("textDocument/formatting") then
                            -- Format the current buffer on save
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                buffer = args.buf,
                                callback = function()
                                    -- vim.lsp.buf.format({bufnr = args.buf, id = client.id})
                                end,
                            })
                        end
                        if client:supports_method("textDocument/definition") then
                            -- Enable jump to definition

                            -- Go back one level up the tag stack
                            vim.keymap.set("n", "<Leader>[", ":pop<CR>")
                            -- Search for tag using regexp, jump if only one, otherwise, list options
                            vim.keymap.set("n", "<Leader>/", ":tj<Space>/")
                            -- Search for tag using regexp, jump if only one, otherwise, list options
                            vim.keymap.set("n", "<Leader>]", ':execute "tj" expand("<cword>")<CR>')
                        end
                    end,
                })

                if vim.fn.executable("rust-analyzer") == 1 then
                    vim.lsp.enable('rust_analyzer')
                end
                vim.lsp.config('rust_analyzer', {
                    on_attach = function(client, bufnr)
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    end,
                    settings = {
                        ["rust-analyzer"] = {
                            check = {
                                command = "clippy",
                            },
                            cargo = {
                                features = "all",
                            },
                            diagnostics = {
                                enable = true,
                            },
                        },
                    },
                })
                if vim.fn.executable('ruff') == 1 then
                    vim.lsp.enable('ruff')
                end
                vim.lsp.config('ruff', {
                    init_options = {
                        settings = {
                            -- Prioritize filesystem config files over editor settings when present
                            configurationPreference = "filesystemFirst",
                            lineLength = 100,
                            lint = {
                                ignore = {
                                    -- from {name} import * used; unable to detect undefined names
                                    "F403",
                                    -- {name} may be undefined, or defined from star imports
                                    "F405",
                                },
                            },
                        },
                    },
                })
                -- if vim.fn.executable('pyright') == 1 then
                --     vim.lsp.enable('pyright')
                -- end
                -- vim.lsp.config('pyright', {
                --     offset_encoding = "utf-8",
                --     trace = "debug",
                --     settings = {
                --         python = {
                --             analysis = {
                --                 logLevel = "Information",
                --                 typeCheckingMode = "off",
                --                 autoSearchPaths = true,
                --                 useLibraryCodeForTypes = true,
                --                 diagnosticMode = "off",
                --                 diagnosticMode = "workspace",
                --                 autoImportCompletions = true,
                --             },
                --             linting = {
                --                 -- I'm using ruff to lint, so don't do double-duty
                --                 enabled = false,
                --             }
                --         }
                --     },
                --     -- Disable all diagnostics from Pyright
                --     -- handlers = {
                --     --   ["textDocument/publishDiagnostics"] = function() end,
                --     -- }
                -- })

                if vim.fn.executable('jedi-language-server') == 1 then
                    vim.lsp.enable('jedi_language_server')
                end
                vim.lsp.config('jedi_language_server', {
                    init_options = {
                        diagnostics = {
                            enable = false,
                            --logLevel = "Information",
                            --typeCheckingMode = "off",
                            --autoSearchPaths = true,
                            --useLibraryCodeForTypes = true,
                            --diagnosticMode = "off",
                            --diagnosticMode = "workspace",
                            --autoImportCompletions = true,
                        },
                        jediSettings = {
                            debug = true,
                        }
                    },
                })
                if vim.fn.executable('clangd') == 1 then
                    vim.lsp.enable('clangd')
                end
                vim.lsp.config('clangd', {
                    cmd = {
                        "clangd",
                        "--compile-commands-dir=./bin/",
                        "--background-index",
                        "--clang-tidy",
                        "--log=verbose",
                    },
                    init_options = {
                        fallbackFlags = {
                            "-std=gnu99",
                            "-Wall",
                        },
                    },
                })
                if vim.fn.executable('eslint-language-server') == 1 then
                    vim.lsp.enable('eslint')
                end
                vim.lsp.config('eslint', {
                    cmd = {
                        "eslint-language-server",
                        "--stdio",
                    },
                })
            end,
        },
    },
    -- Lazy plugin manager config
    {
        checker = {
            enabled = true,
        },
    }
)

--Set proper python paths
vim.g.python_host_prog = "/usr/bin/python2"
vim.g.python3_host_prog = "/usr/bin/python3"

--Use a dark background
vim.opt.background = "dark"

--Show absolute column numbers
vim.opt.number = true

--Reread a file if Vim didn't touch it
vim.opt.autoread = true

--Display cursor position in file
vim.opt.ruler = true

--Number of lines in cmd height
vim.opt.cmdheight = 2

--Unload buffers that are no longer in use
vim.opt.hidden = false

--Show the current command
vim.opt.showcmd = true

--Enable list mode to show whitespace
vim.opt.list = true

--Don't be so pedantic about case
vim.opt.ignorecase = true
vim.opt.smartcase = true

--Highlight all search matches
vim.opt.hlsearch = true
--Search the incremental pattern, rather than when I press enter
vim.opt.incsearch = true

--Don't repaint when executing macros
vim.opt.lazyredraw = true

--Modern magic characters instead of vi legacy cruft
vim.opt.magic = true

--Brief jump to matching brace if it's on screen
vim.opt.showmatch = true

--No sounds or flashing lights, I'm not a child
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.belloff = "all"
vim.opt.tm = 500

--Show open/close folds
vim.opt.foldcolumn = "1"

--Use utf8 like a normal person
vim.opt.encoding = "utf8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8"

--LF is the only acceptable line ending
vim.opt.ffs = unix, dos, mac

--Tabs are 4 spaces
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

--100 char line highlight
vim.opt.colorcolumn = "100"

--Enable auto and smart indent
vim.opt.autoindent = true
vim.opt.smartindent = true

--When in Rome...
vim.opt.copyindent = true

--Enable line wrapping
vim.opt.wrap = true

vim.opt.ssop:remove({
    --Do not store global and local values in a session
    "options",
    ----Do not store folds
    "folds",
    ----Do not store hidden and unloaded buffers
    "buffers",
    ----Do not store the help window
    "help",
})

--Allow me to use the mouse on terminal vim
vim.opt.mouse = "a"

--Ask me if I'm doing something dumb
vim.opt.confirm = true

--Be smart about backspacing
vim.opt.backspace = "indent,eol,start"

--Wildcard/enhanced menu mode
vim.opt.wildmenu = true

--Save all mistakes and edits
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000

--visualize whitepsace
vim.opt.listchars = "tab:→→,trail:●,nbsp:○"

--vim.opt.up scratch file saving
--vim.g.scratch_persistence_file = vim.fn.strftime(vim.g.scratch_dir .. "scratch_%Y-%m-%d")
vim.g.scratch_no_mappings = 1

--share vim and system clipboard
if vim.fn.has("unnamedplus") then
    vim.opt.clipboard = "unnamed,unnamedplus"
else
    vim.opt.clipboard = "unnamed"
end

--enable true 24-bit colour
vim.opt.tgc = true

--vim.opt.shell to bash
if vim.env.SHELL then
    vim.opt.shell = vim.env.SHELL
else
    vim.opt.shell = "/bin/bash"
end

--Update things after 1 second being idle
vim.opt.updatetime = 1000

--Leader as space, since \ is awkward
vim.g.mapleader = " "

--This is gross, but it lets me do stuff like "gf" to open the file under the cursor
vim.opt.path = "**"

--New splits go on the right, I'm not an animal
vim.opt.splitright = true

--Let's ignore tons of garbage/binary/random files
vim.opt.wildmode = "list:longest,list:full"
vim.opt.wildignore:append(ignoreglobs)

-- Prefer using rg for vim grepping if it exists on the system
if vim.fn.executable("rg") == 1 then
    vim.g.grepprg = "rg --vimgrep"
end

-- [BINDINGS]
-- Tab nav with shift
vim.keymap.set("n", "H", "gT")
vim.keymap.set("n", "L", "gt")
-- Tab move with Ctrl
vim.keymap.set("n", "<C-h>", function()
    vim.cmd.tabmove("-1")
end)
vim.keymap.set("n", "<C-l>", function()
    vim.cmd.tabmove("+1")
end)
-- Tab management with t leader
-- Open new tab at end of tab list
vim.keymap.set("n", "tn", function()
    vim.cmd.tabnew("$")
end)
-- Close the current tab
vim.keymap.set("n", "tq", vim.cmd.tabclose)
-- Open the filename under cursor at end of tab list
vim.keymap.set("n", "tf", "<C-w>gf<CR>:tabmove<CR>")

-- Open the filename under cursor as a new window
vim.keymap.set("n", "<Leader>f", "<C-w><C-f><C-w>L")

-- Move on visual lines, not on wrapped/real ones
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<Up>", "g<Up>")
vim.keymap.set("n", "<Down>", "g<Down>")

-- how dare you not use regex by default
vim.keymap.set("n", "/", "/\\v")
vim.keymap.set("v", "/", "/\\v")

-- keep visual selection after shift
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- i never want the help page! i always wanted ESC
vim.keymap.set("n", "<F1>", "<ESC>")
vim.keymap.set("i", "<F1>", "<ESC>")

-- We're not in the 1970's, ex is not a better ed, disable ex mode
vim.keymap.set("n", "Q", "<nop>")

-- [Window management]
-- Ctrl-W is stupid, just rebind it to Alt instead
-- Benefit is that Alt can be held for multiple ops

-- Basic movement
vim.keymap.set("n", "<A-h>", "<C-W>h")
vim.keymap.set("n", "<A-j>", "<C-W>j")
vim.keymap.set("n", "<A-k>", "<C-W>k")
vim.keymap.set("n", "<A-l>", "<C-W>l")

-- Window movement
vim.keymap.set("n", "<A-H>", "<C-W>H")
vim.keymap.set("n", "<A-J>", "<C-W>J")
vim.keymap.set("n", "<A-K>", "<C-W>K")
vim.keymap.set("n", "<A-L>", "<C-W>L")

-- New window creation
vim.keymap.set("n", "<A-n>", vim.cmd.vnew)
vim.keymap.set("n", "<A-s>", "<C-W>s")
vim.keymap.set("n", "<A-v>", "<C-W>v")

-- Quit the current window
vim.keymap.set("n", "<A-q>", "<C-W>q")

-- Resizing
vim.keymap.set("n", "<A-->", "<C-W>-")
vim.keymap.set("n", "<A-+>", "<C-W>+")
vim.keymap.set("n", "<A-<>", "<C-W><")
vim.keymap.set("n", "<A->>", "<C-W>>")
vim.keymap.set("n", "<A-=>", "<C-W>=")
vim.keymap.set("n", "<A-_>", "<C-W>_")

-- Re-select our last pasted block
vim.keymap.set("n", "gp", "`[v`]")

-- allow the . to execute once for each line of a visual selection
vim.cmd("vnoremap . :normal! .<CR>")
--vim.keymap.set('v', '.', vim.cmd(':normal! .<CR>'))

-- Allows a macro to easily be executed on every line of a visual selection
vim.cmd("vnoremap @ :'<,'>norm! @")
-- vim.keymap.set('v', '@', vim.cmd(":'<,'>norm! @"))

-- S and cc are duplicates so mimic the inverse of J for S
vim.cmd("nnoremap S :keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==<CR>")
--vim.keymap.set('n', 'S', vim.cmd{'substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==<CR>', keeppatterns = true})

-- [AUTOCOMMANDS]

-- when the window gets resized reset the splits
vim.api.nvim_create_autocmd({ "VimResized" }, {
    command = "wincmd =",
})

-- Jump to last open
-- Too many nested quotes that make it difficult to translate directly
vim.cmd([[
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]])

vim.api.nvim_create_autocmd({ "VimResized" }, {
    command = "wincmd =",
})

-- Close preview window after insertion completion
vim.api.nvim_create_autocmd({ "CompleteDone" }, {
    command = "pclose",
})

vim.cmd([[

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



"function MoveToPrevTab()
"    "there is only one window
"    if tabpagenr('$') == 1 && winnr('$') == 1
"        return
"    endif
"    "preparing new window
"    let l:tab_nr = tabpagenr('$')
"    let l:cur_buf = bufnr('%')
"    if tabpagenr() != 1
"        close!
"        if l:tab_nr == tabpagenr('$')
"            tabprev
"        endif
"        sp
"    else
"        close!
"        exe "0tabnew"
"    endif
"    "opening current buffer in new window
"    exe "b".l:cur_buf
"endfunc
"
"function MoveToNextTab()
"    "there is only one window
"    if tabpagenr('$') == 1 && winnr('$') == 1
"        return
"    endif
"    "preparing new window
"    let l:tab_nr = tabpagenr('$')
"    let l:cur_buf = bufnr('%')
"    if tabpagenr() < tab_nr
"        close!
"        if l:tab_nr == tabpagenr('$')
"            tabnext
"        endif
"        sp
"    else
"        close!
"        tabnew
"    endif
"    "opening current buffer in new window
"    exe "b".l:cur_buf
"endfunc

"[BINDINGS]
"Automatically split multiple files given via command line into their own tabs
if !&diff && argc() > 1
    autocmd VimEnter * nested :execute 'silent argdo :tab split' | tabclose
endif

"[Window management]
"Window movement
nnoremap <A-.> :call MoveToNextTab()<CR>
nnoremap <A-,> :call MoveToPrevTab()<CR>


"[PLUGIN CONFIG]

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

]])
