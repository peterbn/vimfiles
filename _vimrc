set nocompatible

" Required Vundle setup
filetype off
set runtimepath+=~/.vim/bundle/vundle
call vundle#rc()

" Load vundle as a starter
Bundle 'gmarik/vundle'

Bundle 'vim-latex/vim-latex'
Bunde 'fholgado/minibufexpl.vim'
Bunde 'scrooloose/nerdcommenter'
Bunde 'scrooloose/nerdtree'
Bunde 'altercation/vim-colors-solarized'
Bunde 'ervandew/supertab'
Bunde 'tpope/vim-classpath'
Bunde 'guns/vim-clojure-static'
Bunde 'tpope/vim-fireplace.'
Bunde 'tfnico/vim-gradle'
Bunde 'PProvost/vim-ps1'
Bunde 'guns/vim-sexp'

"source $VIMRUNTIME/vimrc_example.vim
" source $VIMRUNTIME/mswin.vim
" behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

if has("win32")
  set guifont=Consolas:h11:cANSI "nicer font
endif
set guioptions-=T "remove toolbar
set shellslash
set ruler
set cursorline

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden
set backspace=indent,eol,start

let mapleader=","


" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
"set list listchars=tab:\ \ ,trail:�

set wrap         "wrap them lines
"set showbreak=:>>>
set linebreak    "Wrap lines at convenient points
set breakat=\ ^I!@*-+;:,./?" 
set number nuw=3


" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Colors ===========================
set showmatch     " set show matching parenthesis
if has("gui_running")
  set background=light
  colorscheme solarized
  syntax on
else
  set background=dark
endif


" ================ File type specifics===============
let g:tex_flavor="latex"
autocmd Filetype html,xml,xsl source ~/vimfiles/bundle/userscripts/scripts/closetag.vim


" NERDTree setup ftw
" Toggle on F1 (instead of useless help)
map <F1> :NERDTreeToggle<CR>
" Open NERDTree if vim is started without file arguments
"autocmd vimenter * if !argc() | NERDTree | endif
let NERDTreeHijackNetrw=1


