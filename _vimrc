set nocompatible

" ===========================================================
" PLUGINS
" ===========================================================
"
call plug#begin('~/.vim/bundle')

Plug 'scrooloose/nerdcommenter'

" Linting
if has('nvim')
    Plug 'benekastah/neomake'

    let g:neomake_warning_sign = {'text': 'w', 'texthl': 'WarningMsg'}
    let g:neomake_error_sign = {'text': 'EE', 'texthl': 'ErrorMsg'}
    let g:neomake_logfile='/tmp/neomake.err.log'
    let g:neomake_go_enabled_makers = ['gometalinter']

    autocmd! BufWritePost * Neomake
    autocmd! BufEnter * Neomake

    let g:python_host_prog = '/usr/local/bin/python'
else
    Plug 'scrooloose/syntastic'
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 0
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_use_quickfix_lists = 1
    let g:syntastic_python_checkers = ['flake8']
    let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck']
    "let g:syntastic_go_checkers = ['gofmt', 'golint', 'gometalinter', 'gotype', 'govet', 'errcheck']
    let g:syntastic_javascript_checkers = ['jshint']
    let g:syntaxed_languages ='vim,tex,python,pyrex,c,cpp,php,js,html,css,cs,java,md,mkd,markdown,rst,go,node,js'
endif
cabbrev ln lNext

" Fuzzy search
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
nmap <silent> <C-P> :Files<CR>
let g:fzf_layout = { 'down': '~15%' }

Plug 'vim-scripts/camelcasemotion'
" Replace the default 'w', 'b' and 'e' mappings instead of defining additional
" mappings',w', ',b' and ',e' for CamelCase (and_underscore) movement.
" (Note shift+W/B preserves the default behavior.)
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

" For ]l and [l to jump between errors.
Plug 'tpope/vim-unimpaired'

" All the basics.
Plug 'tpope/vim-sensible'

" git blame ilu ;)
Plug 'tpope/vim-fugitive'

" Language support
Plug 'fatih/vim-go', {'for': 'go'}
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"

Plug 'tpope/vim-rails', {'for': 'ruby'}
Plug 'moll/vim-node', {'for': 'javascript'}
Plug 'rodjek/vim-puppet', {'for': 'puppet'}
Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}

if version > 703
    Plug 'Valloric/YouCompleteMe',
        \ {'do': './install.py --clang-completer --gocode-completer'}
    let g:ycm_global_ycm_extra_conf = '.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
    let g:ycm_min_num_of_chars_for_completion = 2
    let g:ycm_autoclose_preview_window_after_completion = 1
    let g:ycm_autoclose_preview_window_after_insertion = 1
endif

" Don't show the preview window on autocompletions.
set completeopt=menuone,longest
"
" Keep a small completion window.
set pumheight=6

" Snippets
Plug 'honza/vim-snippets'

if version > 703
    Plug 'SirVer/ultisnips'

    " YouCompleteMe/Ultisnips compatibility. UltiSnips passes <tab> to SuperTab.
    Plug 'ervandew/supertab'
    let g:SuperTabDefaultCompletionType = '<C-n>'
    let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
    let g:UltiSnipsExpandTrigger = "<tab>"
    let g:UltiSnipsJumpForwardTrigger = "<tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
else
    " Snippet support for legacy vim.
    Plug 'garbas/vim-snipmate'
    Plug 'marcweber/vim-addon-mw-utils'
    Plug 'tomtom/tlib_vim'
endif

" Colorschemes
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'Lokaltog/vim-distinguished'
Plug 'atelierbram/vim-colors_duotones' " base16-duotones
Plug 'sjl/badwolf'
Plug 'vim-scripts/vilight.vim'
Plug 'ninja/sky'
Plug 'notpratheek/vim-luna'
Plug 'nanotech/jellybeans.vim'
Plug 'justinmk/molokai'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1

call plug#end()

" ===========================================================
" EDITOR SETTINGS
" ===========================================================

" Syntax highlighting.
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
colorscheme jellybeans

filetype off                  " need to turn this off fof the next line to work
filetype plugin indent on     " enable loading indent file for filetype

" Multiple windows, when created, are equal in size.
set equalalways

" Set where sp and vsp open new windows.
set splitbelow splitright

" Display line numbers on the left side.
set number

" Inserts new line without going into insert mode.
map <S-CR> O<ESC>
map <CR> o<ESC>

" Change the leader to be a comma vs slash.
let mapleader=","

" Toggle invisible chars
map <leader>i :set list!<CR>

" <tab> inserts 4 spaces.
set tabstop=4

" but an indent level is 2 spaces wide.
set shiftwidth=4

" <BS> over an autoindent deletes both spaces.
set softtabstop=4

" Use spaces, not tabs, for autoindent/tab key.
set expandtab

" Have a line indicate the cursor location.
set cursorline
set cursorcolumn

" Show a line at column 80
if exists("&colorcolumn")
    let &colorcolumn="80,".join(range(100,999),",")
endif

" Don't wrap text at the edge of the window.
set nowrap

" Keep 3 context lines above and below the cursor.
set scrolloff=3

" Briefly jump to a paren once it's balanced.
set showmatch

" (for only 1 second).
set matchtime=1

" Default to using case insensitive searches,
set ignorecase

" Highlight searches by default.
set hlsearch

" Ignore these files when tab completing
set wildignore+=*.o,*.obj,.git,*.pyc,*.so

" Show title in console title bar.
set title

" Always show statusline, even if only 1 window.
set laststatus=2
if exists('fugitive')
    set statusline+=%<%f\ (%{&ft})%=%-19(%3l,%02c%03V%)%{fugitive#statusline()}
endif

" Listen for mouse clicks.
set mouse=a

" Y-N-C prompt if closing with unsaved changes.
set confirm

" Disable all bells. I hate ringing/flashing.
set vb t_vb=

" Remove trailing whitespace on saves.
function! TrimWhiteSpace()
    %s/\s*$//
    ''
:endfunction
autocmd FileWritePre * :call TrimWhiteSpace()
autocmd FileAppendPre * :call TrimWhiteSpace()
autocmd FilterWritePre * :call TrimWhiteSpace()
autocmd BufWritePre * :call TrimWhiteSpace()

" This beauty remembers where you were the last time you edited the file, and
" returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif""

" Enable spell checking for markdown files and git commits.
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd filetype crontab setlocal nobackup nowritebackup
