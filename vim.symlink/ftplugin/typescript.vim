let g:tsuquyomi_disable_default_mappings = 1
nnoremap <silent> <leader>gd :TsuDefinition<cr>
nnoremap <silent> <leader>ge :TsuGeterr<cr>
nnoremap <silent> <leader>gk :TsuGoBack<cr>
nnoremap <silent> <leader>gi :echo tsuquyomi#hint()<cr>
nnoremap <silent> <leader>go :Unite outline<cr>
nnoremap <silent> <leader>gr :TsuReferences<cr>
nnoremap <silent> <leader>gs :TsuSignatureHelp<cr>
