" Language   : Scala (http://scala-lang.org/)
" Maintainer : Stefan Matthias Aust
" Last Change: 2006 Apr 13

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetScalaIndent()

setlocal indentkeys=0{,0},0),!^F,&lt;&gt;&gt;,o,O

setlocal autoindent shiftwidth=2 tabstop=2 softtabstop=2 expandtab

if exists("*GetScalaIndent")
  finish
endif

function! CountParens(line)
  let line = substitute(a:line, '"\(.\|\\"\)*"', '', 'g')
  let open = substitute(line, '[^(]', '', 'g')
  let close = substitute(line, '[^)]', '', 'g')
  return strlen(open) - strlen(close)
endfunction

function! GetScalaIndent()
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)
  let prevline = getline(lnum)

  "Indent html literals
  if prevline !~ '/&gt;\s*$' &amp;&amp; prevline =~ '^\s*&lt;[a-zA-Z][^&gt;]*&gt;\s*$'
    return ind + &amp;shiftwidth
  endif

  " Add a 'shiftwidth' after lines that start a block
  " If if, for or while end with ), this is a one-line block
  " If val, var, def end with =, this is a one-line block
  if prevline =~ '^\s*\&lt;\(\(else\s\+\)\?if\|for\|while\)\&gt;.*[)]\s*$'
        \ || prevline =~ '^\s*\&lt;\(\(va[lr]\|def\)\&gt;.*[=]\s*$'
        \ || prevline =~ '^\s*\&lt;else\&gt;\s*$'
        \ || prevline =~ '{\s*$'
    let ind = ind + &amp;shiftwidth
  endif

  " If parenthesis are unbalanced, indent or dedent
  let c = CountParens(prevline)
  echo c
  if c &gt; 0
    let ind = ind + &amp;shiftwidth
  elseif c &lt; 0
    let ind = ind - &amp;shiftwidth
  endif
  
  " Dedent after if, for, while and val, var, def without block
  let pprevline = getline(prevnonblank(lnum - 1))
  if pprevline =~ '^\s*\&lt;\(\(else\s\+\)\?if\|for\|while\)\&gt;.*[)]\s*$'
        \ || pprevline =~ '^\s*\&lt;\(\va[lr]\|def\)\&gt;.*[=]\s*$'
        \ || pprevline =~ '^\s*\&lt;else\&gt;\s*$'
    let ind = ind - &amp;shiftwidth
  endif

  " Align 'for' clauses nicely
  if prevline =~ '^\s*\&lt;for\&gt; (.*;\s*$'
    let ind = ind - &amp;shiftwidth + 5
  endif

  " Subtract a 'shiftwidth' on '}' or html
  let thisline = getline(v:lnum)
  if thisline =~ '^\s*[})]' 
        \ || thisline =~ '^\s*&lt;/[a-zA-Z][^&gt;]*&gt;'
    let ind = ind - &amp;shiftwidth
  endif

  " Indent multi-lines comments
  if prevline =~ '^\s*\/\*\($\|[^*]\(\(\*\/\)\@!.\)*$\)'
    let ind = ind + 1
  endif

  " Indent multi-lines ScalaDoc
  if prevline =~ '^\s*\/\*\*\($\|[^*]\(\(\*\/\)\@!.\)*$\)'
    let ind = ind + 2
  endif

  " Dedent after multi-lines comments &amp; ScalaDoc
  if prevline =~ '^\s*\(\(\/\*\)\@!.\)*\*\/.*$'
    " Dedent 1
    let ind = ind - 1
    " Align to any multiple of 'shiftwidth'
    let ind = ind - (ind % &amp;shiftwidth)
  endif

  return ind
endfunction
