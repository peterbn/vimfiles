
if exists('userscripts') || &cp
    finish
endif
let userscripts=1

function! s:ConvertToUtf8()
  exe "new __Convert__"
  exe "set encoding=latin-1"
  exe "normal! \"+gP"
  exe "set encoding=utf-8"
  exe "normal! ggV\"+y"
  exe "bd"
endfunction

function! s:EaArguments()
  exe "new __Convert__"
  exe "normal! \"+gP"
" Delete context parameter if present
  exe "s/,\\s*\\<Context \\w*\\>\\s*$//" 
" Reverse name and types
  exe "s/\\<\\(\\w*\\)\\> \\<\\(\\w*\\)\\>/\\2:\\1/g"
  exe "normal! ggV\"+y"
  exe "bd"
endfunction

" ScratchMarkBuffer
" Mark a buffer as scratch
function! s:ScratchMarkBuffer()
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal buflisted
endfunction

autocmd BufNewFile __Convert__ call s:ScratchMarkBuffer()

command! -nargs=0 ConvertToUtf8 call s:ConvertToUtf8()
command! -nargs=0 EaArguments call s:EaArguments()
