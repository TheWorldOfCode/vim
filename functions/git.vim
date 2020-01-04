


function! Git_check_in_repository(filepath)

"	if has("python") || has("python3") 

"	else
		let tmp = system("(cd " . a:filepath .  ";git rev-parse --is-inside-work-tree 2>/dev/null) | tr -d '\r' | tr -d '\n'")
		redraw!
		if tmp =~  "true"
			return 1
		endif

"	endif 

	return 0
endfunction


function! Git_get_current_branch()

"	if has("python") || has("python3)
"	else
		let l:branch = system("git symbolic-ref --short HEAD 2>/dev/null | tr -d '\n'")

		redraw! 
		return len(branch) > 0?' '. l:branch .':' :''
"	endif
	return ''
endfunction


function! Git_check_if_file_is_tracked(filename)

"	if has("python") || has("python3")
"	else
		let l:fileStatus = system("git ls-files "  . a:filename . " 2>/dev/null | tr -d '\r' | tr -d '\n'")
		redraw!

		if strlen(l:fileStatus) > 0 
			return 1
		endif

"	endif

	return 0
endfunction

function! Git_statusline_current_branch()

	if exists("b:GitInRepository") && exists("b:GitCurrentBranch") &&  b:GitInRepository == 1
		return b:GitCurrentBranch
	endif	

	return ''
endfunction

function! Git_statusline_file_tracked()


	if exists("b:GitInRepository") && exists("b:GitFileTracked") && b:GitInRepository == 1
		return 'Track:' . b:GitFileTracked
	endif	

	return ''
endfunction


let b:GitInRepository=Git_check_in_repository(expand('%:p:h'))
let b:GitCurrentBranch=Git_get_current_branch()
let b:GitfileTracked=Git_check_if_file_is_tracked(expand('%:p'))
augroup GIT
	au BufNewFile * : let @d = "NewFile".expand('<abuf>') " Trigger when ******
	au BufNewFile * : let b:GitInRepository=Git_check_in_repository(expand('%:p:h'))
	au BufNewFile * : let b:GitCurrentBranch=Git_get_current_branch() 
	au BufNewFile * : let b:GitFileTracked=Git_check_if_file_is_tracked(expand('%:p'))
	au BufNew *     : let b:GitInRepository=Git_check_in_repository(expand('%:p:h')) " Runned when a new buffer is created, but not the firste buffer vim opens
	au BufNew *     : let b:GitCurrentBranch=Git_get_current_branch() " Runned when a new buffer is created, but not the firste buffer vim opens
	au BufEnter *   : let b:GitFileTracked=Git_check_if_file_is_tracked(expand('%:p')) " Runned every time vim shiftes buffer 
augroup end 
