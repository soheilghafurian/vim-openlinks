" openlinks.vim - Extract and open URLs from lines
" Maintainer: vim-openlinks
" License: MIT

if exists('g:loaded_openlinks')
  finish
endif
let g:loaded_openlinks = 1

command! -range OpenLinks call openlinks#Open(<line1>, <line2>)
