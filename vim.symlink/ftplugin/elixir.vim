set breakat-=:

nnoremap <silent> <leader>et :call ElixirTestSuite()<cr>
nnoremap <silent> <leader>ef :call ElixirTestFile()<cr>
nnoremap <silent> <leader>el :call ElixirTestLine()<cr>

function! ElixirTestSuite()
  VimuxRunCommand("mix test")
endfunction

function! ElixirTestFile()
  VimuxRunCommand("mix test " . expand("%:p"))
endfunction

function! ElixirTestLine()
  VimuxRunCommand("mix test " . expand("%:p") . ":" . line("."))
endfunction

