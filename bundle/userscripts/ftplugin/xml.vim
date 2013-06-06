fun! XmlExpand()
  %s§>\@<=<\S\{-}>§\r&§g
  normal gg=Ggg
endfunction
com! XmlExpand :call XmlExpand()
