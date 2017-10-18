set nolist
set tabstop=8
set colorcolumn=

nnoremap <silent> <leader>gd :GoDef<cr>
nnoremap <silent> <leader>ge :GoErrCheck<cr>
nnoremap <silent> <leader>gk :GoDefPop<cr>
nnoremap <silent> <leader>gi :GoInfo<cr>
nnoremap <silent> <leader>gr :GoReferrers<cr>
nnoremap <silent> <leader>gs :TsuSignatureHelp<cr>

augroup go_autocmd
  autocmd! * <buffer>
  autocmd BufWritePost <buffer> :GoImports
augroup END
