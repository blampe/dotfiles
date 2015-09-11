set nocompatible

" ===========================================================
" PLUGINS
" ===========================================================
"
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" Let Vundle manage Vundle
Plugin 'gmarik/vundle'

Plugin 'scrooloose/nerdcommenter'

" Linting
Plugin 'scrooloose/syntastic'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_use_quickfix_lists = 1
let g:syntastic_python_checkers = ['flake8']
cabbrev ln lNext

Plugin 'vim-scripts/camelcasemotion'
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
Plugin 'tpope/vim-unimpaired'

" All the basics.
Plugin 'tpope/vim-sensible'

" gblame ilu ;)
Plugin 'tpope/vim-fugitive'

" Language support
Plugin 'fatih/vim-go'
Plugin 'tpope/vim-rails'
Plugin 'moll/vim-node'
Plugin 'rodjek/vim-puppet'
Plugin 'solarnz/thrift.vim'
Plugin 'vim-ruby/vim-ruby'

if v:version > 735
    Plugin 'Valloric/YouCompleteMe'
    let g:ycm_global_ycm_extra_conf = '.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
    let g:ycm_min_num_of_chars_for_completion = 2
    let g:ycm_autoclose_preview_window_after_completion = 1
    let g:ycm_autoclose_preview_window_after_insertion = 1
endif

" Don't show the preview window on autocompletions.
set completeopt=menuone,longest
"set completeopt=menuone,longest,preview
"
" Keep a small completion window.
set pumheight=6

" Snippets
if v:version > 740
    Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'

    " YouCompleteMe/Ultisnips compatibility. UltiSnips passes <tab> to SuperTab.
    Plugin 'ervandew/supertab'
    let g:SuperTabDefaultCompletionType = '<C-n>'
    let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
    let g:UltiSnipsExpandTrigger = "<tab>"
    let g:UltiSnipsJumpForwardTrigger = "<tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
endif

call vundle#end()

" ===========================================================
" EDITOR SETTINGS
" ===========================================================

" Syntax highlighting.
set t_Co=16
colorscheme ir_black
set background=dark

filetype on                   " try to detect filetypes
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

" Show a line at column 100
if exists("&colorcolumn")
    set colorcolumn=100
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
