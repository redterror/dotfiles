filetype on
filetype plugin on
filetype indent on

syntax on

" 2 spaces for a tab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab

set ai
let g:rubycomplete_rails = 1
set background=dark

set incsearch
set hlsearch

" Shows EOL markers (and more?)
"set list

set history=50          " keep 50 lines of command line history
"set ruler              " show the cursor position all the time
set showcmd             " display incomplete commands

" Show matching brackets.
set showmatch
" have % bounce between angled brackets, as well as t'other kinds:
"set matchpairs+=<:>
set comments=s1:/*,mb:*,ex:*/,f://,b:#,:%,:XCOMM,n:>,fb:-
" This being the 21st century, I use Unicode
set encoding=utf-8

" Store swap files in fixed location, not current directory.
" http://stackoverflow.com/a/4331812/845546
set dir=~/.vimswap//,/var/tmp//,/tmp//,.

" Always display the status line
"set laststatus=2

" Display extra whitespace
" set list listchars=tab:»·,trail:·

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif
