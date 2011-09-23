filetype on
filetype plugin on
filetype indent on

syntax on
set tabstop=2
set shiftwidth=2
set softtabstop=2
set ai
set expandtab
set smarttab
let g:rubycomplete_rails = 1
set background=dark

set incsearch
set hlsearch


set history=50          " keep 50 lines of command line history
"set ruler              " show the cursor position all the time
set showcmd             " display incomplete commands

" Always display the status line
"set laststatus=2

" Display extra whitespace
" set list listchars=tab:»·,trail:·

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif
