" vim:fdm=marker
set nocompatible

" ===========================================================
" PLUGINS
" ===========================================================

call plug#begin('~/.vim/bundle')

Plug 'fatih/vim-go', {'for': 'go'} " Language support
Plug 'honza/vim-snippets' " Snippets
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' " Fuzzy search
Plug 'mhinz/vim-startify' " MRU startup screen
Plug 'moll/vim-node', {'for': 'javascript'} " Language support
Plug 'rodjek/vim-puppet', {'for': 'puppet'} " Language support
Plug 'scrooloose/nerdcommenter' " Smart comment blocks
Plug 'solarnz/thrift.vim', {'for': 'thrift'} " Language support
Plug 'tbabej/taskwiki', {'do': 'pip3 install --upgrade git+git://github.com/tbabej/tasklib@develop'} " Taskwarrior TODO lists
Plug 'tpope/vim-rails', {'for': 'ruby'} " Language support
Plug 'tpope/vim-sensible' " Sensible defaults for basics
Plug 'tpope/vim-unimpaired' " ]* and *[ helper commands
Plug 'vim-airline/vim-airline'
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'} " Language support
Plug 'vim-scripts/camelcasemotion' " Navigation within words
Plug 'vimwiki/vimwiki' " Smart markdown wikis
Plug 'hashivim/vim-terraform'
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'

" colorschemes{{{
Plug 'Lokaltog/vim-distinguished'
Plug 'atelierbram/vim-colors_duotones' " base16-duotones
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'justinmk/molokai'
Plug 'nanotech/jellybeans.vim'
Plug 'ninja/sky'
Plug 'notpratheek/vim-luna'
Plug 'sjl/badwolf'
Plug 'vim-scripts/vilight.vim'"}}}

if has('nvim')
    source ~/.vim/custom/neovim.vim
else
    source ~/.vim/custom/vanilla.vim
endif

call plug#end()

" ===========================================================
" PLUGIN CONFIGS
" ===========================================================

" junegunn/fzf{{{
nmap <silent> <C-P> :Files<CR>
let g:fzf_layout = { 'down': '~25%' }
"}}}

" vim-scripts/camelcasemotion{{{
" Replace the default 'w', 'b' and 'e' mappings instead of defining additional
" mappings',w', ',b' and ',e' for CamelCase (and_underscore) movement.
" (Note shift+W/B preserves the default behavior.)
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
"}}}

" mhinz/vim-startify{{{
let g:startify_change_to_vcs_root = 1
"}}}

" vimwiki/vimwiki{{{
let g:taskwiki_markup_syntax = "markdown"
let g:taskwiki_disable_concealcursor = 1
function! s:buildWiki(path)
	return {
		\ 'syntax': 'markdown',
		\ 'ext': '.md',
		\ 'auto_toc': 1,
		\ 'list_margin': 0,
		\ 'path': a:path,
		\ }
endfunction
let g:vimwiki_hl_headers = 1
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_ext2syntax = {'.md': 'markdown'}
let g:vimwiki_autowriteall = 1
let g:vimwiki_auto_chdir = 1
let g:vimwiki_use_mouse = 1
"}}}

" faith/vim-go{{{
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_def_mode = 'godef'
"}}}

" vim-airline/vim-airline{{{
let g:airline_powerline_fonts = 1
let g:airline_extensions = ['branch']
set noshowmode
"}}}

" hashivim/vim-terraform
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" ===========================================================
" EDITOR SETTINGS
" ===========================================================

" Syntax highlighting and color.
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
colorscheme jellybeans
highlight Pmenu ctermbg=NONE ctermfg=white guibg=NONE guifg=white

filetype off                  " need to turn this off fof the next line to work
filetype plugin indent on     " enable loading indent file for filetype

" Show a line at column 80
if exists("&colorcolumn")
    let &colorcolumn="80,".join(range(100,999),",")
endif

" Show lint errors in the same column as line numbers
"set signcolumn=number

" Don't show the preview window on autocompletions.
" set completeopt=menu,menuone,preview,noselect,noinsert
"set completeopt=menuone,longest
set completeopt=noinsert,menuone,noselect,preview

" Keep a small completion window.
set pumheight=9

set foldmethod=marker

" Multiple windows, when created, are equal in size.
set equalalways

" Set where sp and vsp open new windows.
set splitbelow splitright

" Display line numbers on the left side.
set number

" <tab> inserts 4 spaces.
set tabstop=4
set shiftwidth=4

" <BS> over an autoindent deletes all spaces.
set softtabstop=4

" Use spaces, not tabs, for autoindent/tab key.
set expandtab

" Have a line indicate the cursor location.
set cursorline
set cursorcolumn

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

" Listen for mouse clicks.
set mouse=a

" Y-N-C prompt if closing with unsaved changes.
set confirm

" Disable all bells. I hate ringing/flashing.
set vb t_vb=

" ===========================================================
" KEY BINDINGS
" ===========================================================

" Inserts new line without going into insert mode.
map <S-CR> O<ESC>
map <CR> o<ESC>

" Change the leader to be a comma vs slash.
let mapleader=","

" Toggle invisible chars
map <leader>i :set list!<CR>

" ===========================================================
" BUFFERS AND FILE TYPES
" ===========================================================

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

" In the quickfix window, <CR> is used to jump to the error under the
" cursor, so undefine any mappings there.
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

" Enable spell checking for markdown files and git commits.
autocmd Filetype markdown setlocal spell
autocmd Filetype vimwiki setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd filetype crontab setlocal nobackup nowritebackup
