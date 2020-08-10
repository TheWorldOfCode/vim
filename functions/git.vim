command! GitAdd call Git_add(expand('%:p'))
command! -nargs=1 GitCommit call Git_comment(expand('%:p'), <args> )

function! Git_add(filename)
" Add the file to git

	if exists("b:GitInRepository") && b:GitInRepository == 1
		let l:result = system("git add " . a:filename . " 2>/dev/null")
	endif 

endfunction

function! Git_commit(filename, comment)
" Comment a file 
	if exists("b:GitInRepository") && b:GitInRepository == 1
		let l:result = system("git commit " . a:filename . " -m " . a:comment)
	endif 
endfunction 

function! Git_check_in_repository(filepath)
	let tmp = system("(cd " . a:filepath .  ";git rev-parse --is-inside-work-tree 2>/dev/null) | tr -d '\r' | tr -d '\n'")
	if tmp =~  "true"
		return 1
	endif

	return 0
endfunction


function! Git_get_current_branch()

	let l:branch = system("git symbolic-ref --short HEAD 2>/dev/null | tr -d '\n'")

	return len(branch) > 0?' '. l:branch .':' :''
endfunction


function! Git_check_if_file_is_tracked(filename)

	let l:fileStatus = system("git ls-files "  . a:filename . " 2>/dev/null | tr -d '\r' | tr -d '\n'")

	if strlen(l:fileStatus) > 0 
		return 1
	endif

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


augroup GIT_STATUS
	au BufRead * : let b:GitInRepository=Git_check_in_repository(expand('%:p:h'))
	au BufRead * : let b:GitCurrentBranch=Git_get_current_branch() 
	au BufRead * : let b:GitFileTracked=Git_check_if_file_is_tracked(expand('%:p'))
augroup end 
