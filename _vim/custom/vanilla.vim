" Plugins only used with vanilla vim installations, usually on remote
" instances.

Plug 'scrooloose/syntastic'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_use_quickfix_lists = 1
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck']
let g:syntastic_javascript_checkers = ['jshint']
let g:syntaxed_languages ='vim,tex,python,pyrex,c,cpp,php,js,html,css,cs,java,md,mkd,markdown,rst,go,node,js'
let g:deoplete#enable_at_startup = 1
