


function! AddMethod(type, name) 

  let l:name=substitute(a:name,"_\\(\[a-z\]\\)", "\\U\\1", "")

  put = "/****************************************************"
  put = " * Name: " . l:name . "                             *"
  put = " * Description:                                     *"
  put = " * %%%                                              *"
  put = " ***************************************************/"
  put = a:type . " " . l:name . "()"
  put = "{"
  put = "    %%%%"
  put = "}"
endfunction
