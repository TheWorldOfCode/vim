
function! CPP_ClassMethod(class,  method)

	let l:method = substitute(a:method, "\\s", " " . a:class . "::", "") 
	let l:method = substitute(l:method, ";", "", "") 

	return l:method
endfunction


function! CPP_FindFile(headerfile)

endfunction
