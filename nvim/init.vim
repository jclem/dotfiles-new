call plug#begin()

Plug '$HOME/.fzf'
Plug '/usr/local/opt/fzf'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'Shougo/deoplete.nvim', { 'do': 'UpdateRemotePlugins' }
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/gina.vim'
Plug 'mhartington/nvim-typescript', { 'do': 'UpdateRemotePlugins' }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tmux-plugins/vim-tmux'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'w0rp/ale'

call plug#end()

" Status line
set statusline=%f\ %y\ %h%m%r%w%=%c@%l/%L

" Visual styling
colorscheme Tomorrow-Night
set background=dark
set colorcolumn=100
set lazyredraw
set list
let &listchars='tab:▸ ,extends:❯,precedes:❮,nbsp:±,trail:·'
set number
set numberwidth=4
set fillchars=vert:│,fold:-,diff:-

" Searching
set ignorecase
set smartcase
set tagcase=followscs

" Indentation
set expandtab
set shiftround
set shiftwidth=2
set tabstop=2

" Miscellaneous
set dictionary+=/usr/share/dict/words
set display=truncate
set mouse=a
set report=0
set scrolloff=5
set sidescroll=5
set splitbelow
set splitright
set ttimeoutlen=100

" Wrapping/Line Breaks
set linebreak
set breakindent
set showbreak=...→\ 

" File settings
let netrw_home=$HOME.'/.config/nvim/files'
set backup
set backupdir=$HOME/.config/nvim/files/backup
set backupext=.nvimbackup
set backupskip=
set directory=$HOME/.config/nvim/files/swap//
set shada=!,'1000,%,h,n$HOME/.config/nvim/files/info/shada
set undodir=$HOME/.config/nvim/files/undo
set undofile
set updatecount=100

" Syntax and File Types
syntax enable
filetype plugin indent on

" Deoplete
let deoplete#enable_at_startup=1

" nvim-typescript
let nvim_typescript#signature_complete=1
let nvim_typescript#type_info_on_hold=1

" NERDCommenter
let NERDCommentEmptyLines=1
let NERDSpaceDelims=1
let NERDTrimTrailingWhitespace=1
let NERDDefaultAlign='left'

" NERDTree
let NERDTreeNaturalSort=1

" Mappings
let mapleader = ' '
nnoremap ; :
vnoremap ; :
nnoremap <silent> <leader>vv :source $MYVIMRC<cr>
nnoremap <silent> <leader>vp :source $MYVIMRC<cr> <bar> :PlugInstall<cr>
nnoremap S :%s/
vnoremap S :s/
inoremap kj <esc>
nnoremap <silent> <c-c> :nohlsearch<Bar>:echo<cr>""
nnoremap <silent> <leader>% :let @+ = join([expand("%"), line(".")], ":")<cr>
nnoremap <silent> \ :NERDTreeToggle<cr>

" Language navigation
nnoremap <silent> <leader>gd :TSDef<cr>
nnoremap <silent> <leader>gi :TSDoc<cr>
nnoremap <silent> <leader>gp :TSDefPreview<cr>
nnoremap <silent> <leader>gr :TSRefs<cr>
nnoremap <silent> <leader>gR :TSRename<cr>
nnoremap <silent> <leader>gt :TSType<cr>

" Mappings - Window Navigation
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" Mappings - Splits
nnoremap <silent> <leader>\| :vsplit<cr>
nnoremap <silent> <leader>- :split<cr>

" Mappings - Tabbing
nnoremap <silent> <leader>tt :tabnew<cr>
nnoremap <silent> <leader>tc :tabclose<cr>
nnoremap <silent> } :tabnext<cr>
nnoremap <silent> { :tabprev<cr>

" Mappings - Fuzzy Finding
nnoremap <leader>f? :Helptags<cr>
nnoremap <leader>fa :Ag<cr>
nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>fc :Commands<cr>
nnoremap <leader>fd :FZF<cr>
nnoremap <leader>fg :GFiles?<cr>
nnoremap <leader>fh :History<cr>
nnoremap <leader>fl :BLines<cr>
nnoremap <leader>fm :Marks<cr>
nnoremap <leader>fs :Snippets<cr>
nnoremap <leader>fw :Windows<cr>

" Mappings - Vimux
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
nnoremap <silent> <leader>rc :VimuxInterruptRunner<cr>
nnoremap <silent> <leader>rp :VimuxRunLastCommand<cr>
nnoremap <silent> <leader>rr :VimuxPromptCommand<cr>
nnoremap <silent> <leader>rx :VimuxCloseRunner<cr>
nnoremap <silent> <leader>rz :VimuxZoomRunner<cr>

if filereadable(expand("~/.nvim-local.vim"))
  source ~/.nvim-local.vim
endif

" Secure Local Vim Configuration
set exrc
set secure
