if !has('python')
  echo 'Error: Required vim compiled with +python'
  finish
endif

let s:scriptfile=expand("<sfile>")

function! PrettyPrintMarkup()
  execute "pyfile ".fnameescape(fnamemodify(s:scriptfile, ":h")."/prettyprint.py")
endfunction

command! PrettyPrintMarkup call PrettyPrintMarkup()
