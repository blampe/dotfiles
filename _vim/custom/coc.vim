Plug 'neoclide/coc.nvim', {'branch': 'release'}

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


let g:coc_global_extensions = [
            \ 'coc-eslint',
            \ 'coc-git',
            \ 'coc-go',
            \ 'coc-html',
            \ 'coc-json',
            \ 'coc-python',
            \ 'coc-snippets',
            \ 'coc-solargraph',
            \ 'coc-yaml',
            \ ]
set updatetime=300
set shortmess+=c

" <Tab>: completion forward
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-N>" :
            \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()

" <S-Tab>: completion back
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"

" <CR>: confirm completion, or insert <CR>
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunction

" Use `[q` and `]q` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in
" location list.
nmap <silent> [q <Plug>(coc-diagnostic-prev)
nmap <silent> ]q <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap gc <Plug>(coc-git-commit)


" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 Imports :call CocAction('runCommand', 'editor.action.organizeImport')

 "Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"function! s:show_documentation()
    "if (index(['vim','help'], &filetype) >= 0)
        "execute 'h '.expand('<cword>')
    "elseif (coc#rpc#ready())
        "call CocActionAsync('doHover')
    "else
        "execute '!' . &keywordprg . " " . expand('<cword>')
    "endif
"endfunction
"" Remap <C-f> and <C-b> for scroll float windows/popups.
"" Note coc#float#scroll works on neovim >= 0.4.3 or vim >= 8.2.0750
"nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
