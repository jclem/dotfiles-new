set foldmethod=syntax

let g:tsuquyomi_definition_split=1
let g:tsuquyomi_disable_quickfix=1
let g:tsuquyomi_disable_default_mappings = 1

" Language navigation
nnoremap <silent> <leader>gd :TSDef<cr>
nnoremap <silent> <leader>gi :TSDoc<cr>
nnoremap <silent> <leader>gp :TSDefPreview<cr>
nnoremap <silent> <leader>gr :TSRefs<cr>
nnoremap <silent> <leader>gR :TSRename<cr>
nnoremap <silent> <leader>gt :TSType<cr>
