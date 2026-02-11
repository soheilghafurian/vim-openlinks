" openlinks.vim - Extract and open URLs from lines
" Maintainer: vim-openlinks
" License: MIT

if exists('g:loaded_openlinks')
  finish
endif
let g:loaded_openlinks = 1

command! -range OpenLinks call openlinks#Open(<line1>, <line2>)

if !hasmapto('<Plug>(openlinks)')
  nmap <leader>x <Plug>(openlinks)
  nmap <leader>xx <Plug>(openlinks-line)
  xmap <leader>x <Plug>(openlinks-visual)
endif

nnoremap <Plug>(openlinks) :set opfunc=openlinks#Operator<CR>g@
nnoremap <Plug>(openlinks-line) :call openlinks#Open(line('.'), line('.'))<CR>
xnoremap <Plug>(openlinks-visual) :<C-u>call openlinks#Open(line("'<"), line("'>"))<CR>
