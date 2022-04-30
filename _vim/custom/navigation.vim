" ===========================================================
" EDITOR SETTINGS
" ===========================================================

" Have a line indicate the cursor location.
set cursorline
set cursorcolumn

" Set where sp and vsp open new windows.
set splitbelow splitright

" Default to using case insensitive searches,
set ignorecase

" ===========================================================
" KEY BINDINGS
" ===========================================================

" Change the leader to be a comma vs slash.
let mapleader=","

" Inserts new line without going into insert mode.
map <S-CR> O<ESC>
map <CR> o<ESC>

" Toggle invisible chars
map <leader>i :set list!<CR>

