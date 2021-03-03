command! GitAdd call Git_add(expand('%:p'))
command! -nargs=1 GitCommit call Git_commit(expand('%:p'), <args> )
command! GitCommitAll call Git_popup_leave_all(0)

command! GitQuit        call Git_popup_leaving(0,1)
command! GitQuitAll     call Git_popup_leave_all(1)
command! GitSaveQuit    call s:Git_save(0)
command! GitSaveQuitAll call s:Git_save(1)

let s:id = 0
let s:quit = 0
function! Git_popup_leaving_callback(id, result)
    let g:Gitpopup_return = a:result
    call Git_popup_leaving(s:id + 1, s:quit)
endfunction

function! Git_popup_leaving_commit_filter(id, key)
    echo a:key == "\<CR>"

    if a:key == "\<CR>"
        echo "Closing ". expand('%:p')

        let bufnr = winbufnr(a:id)
        let commit = join(getbufline(bufnr, 1, '$'))
        "        echo s:commit_files
        for f in s:commit_files 
            call Git_add(f)
            call Git_commit(f, commit)
        endfor
        call popup_close(a:id)
        return 1
    else
        call win_execute(a:id, "normal A". a:key)
    endif

    return 1

endfunction

function! Git_popup_leaving(id, quit)
    let s:quit = a:quit

    if exists("b:GitInRepository") && b:GitInRepository == 1
        let s:id = a:id
        if b:GitFileTracked == "M" || b:GitFileTracked == "U"
            if s:id == 0
                if b:GitFileTracked == 0
                    call popup_dialog(expand('%:p').' is untracked, would you track this file (y/n)?', #{
                                \ title: 'Git Warring',
                                \ filter: 'popup_filter_yesno',
                                \ callback: 'Git_popup_leaving_callback'
                                \ })
                else 
                    let g:Gitpopup_return = 1
                    let s:id = 1
                endif 
            endif
            if s:id == 1
                if g:Gitpopup_return == 1
                    call popup_dialog(expand('%:p').' Would you like to commit on the chances? (y/n)', #{
                                \ title: 'Git Warring',
                                \ filter: 'popup_filter_yesno',
                                \ callback: 'Git_popup_leaving_callback'
                                \ })
                else
                    call Git_add(expand("%:p"))
                    let s:id = 3
                endif
            endif

            if s:id == 2
                if g:Gitpopup_return == 1
                    call Git_popup_git_commit([expand('%:p')], "", 'Git_popup_leaving_callback')
                endif
            endif

            if s:id == 3
                if s:quit == 1
                    quit
                endif
            endif
        else
            if s:quit == 1
                quit
            endif
        endif
    else
        if s:quit == 1
            quit
        endif
    endif
endfunction

let s:commit_files = []
function! Git_popup_git_commit(files, title, callback)
    let l:title = 'Git Commit ('. expand("%") .")"
    if strlen(a:title) > 0
        let l:title = a:title
    endif
    let s:commit_files = a:files
    if strlen(a:callback) > 0
        call popup_dialog('', #{
                    \ title: l:title,
                    \ filter: 'Git_popup_leaving_commit_filter',
                    \ callback: a:callback,
                    \ minwidth: 70,
                    \ })
    else
        call popup_dialog('', #{
                    \ title: l:title,
                    \ filter: 'Git_popup_leaving_commit_filter',
                    \ minwidth: 70,
                    \ })
    endif
endfunction

function! Git_popup_leave_all_callback_recall(id, result)
    if len(s:all_list) > 2
        call s:Git_popup_leave_all_create_popup(s:all_list)
    else
        if s:quit == 1
            quit
        endif
    endif
endfunction

let s:all_list = []
function! Git_popup_leave_all_callback(id, result)
    let l:element = s:all_list[a:result - 1]
    if a:result == len(s:all_list) 
        echo "Quit"
        if s:quit == 1
            quit
        endif
    elseif a:result == len(s:all_list) - 1
        echo "Commit on All"
        if s:all_marked_nr == 0
            call Git_popup_git_commit(s:all_list[0:len(s:all_list)-3], "Git commit", "Git_popup_leave_all_callback_recall")
            let s:all_list = []
        else
            let bufnr = winbufnr(a:id)
            let lines = getbufline(bufnr, 1, len(getbufline(bufnr, 1, "$")) - 2)
            let commit_lines =  []
            for line in lines
                if split(line)[0] == '*'
                    call add(commit_lines, split(line)[1])
                endif
            endfor
            call Git_popup_git_commit(commit_lines, "Git commit", "Git_popup_leave_all_callback_recall")
        endif
    else
        call win_execute(bufwinid(l:element), Git_popup_git_commit([l:element], "", "Git_popup_leave_all_callback_recall"))
        call remove(s:all_list, a:result - 1)
    endif


endfunction

let s:all_marked_nr = 0
function! Git_popup_leave_all_filter(id, key)

    if a:key == 'm' || a:key == 's'
        echo "mark"
        let bufnr = winbufnr(a:id)
        let line = getbufline(bufnr, line(".", a:id))[0]

        if split(line)[0] == '*'
            call win_execute(a:id, "normal 0dw")
            let s:all_marked_nr = s:all_marked_nr - 1
        else
            call win_execute(a:id, "normal I". "* ") 
            let s:all_marked_nr = s:all_marked_nr + 1
        endif

        if s:all_marked_nr == 0
            call setbufline(bufnr, len(getbufline(bufnr, 1, "$")) - 1, "Commit all")
        else
            call setbufline(bufnr, len(getbufline(bufnr, 1, "$")) - 1, "Commit selected (" . s:all_marked_nr . ")")
        endif


    endif

    return popup_filter_menu(a:id, a:key)
endfunction

function! s:Git_popup_leave_all_create_popup(list)
    let s:all_list = a:list
    call popup_menu(a:list, #{
                \ filter: 'Git_popup_leave_all_filter',
                \ callback: 'Git_popup_leave_all_callback'
                \} )

endfunction

function! Git_popup_leave_all(quit)
    let s:quit = a:quit
    let s:all_marked_nr = 0

    let l:blist = getbufinfo({'bufloaded': 1, 'buflisted': 1})
    let l:list = []
    for l:item in l:blist
        let l:nr = l:item.bufnr
        if getbufvar(l:nr, "GitInRepository") 
            let l:allowed = getbufvar(l:nr, "GitFileTracked")
            if l:allowed == "U" || l:allowed == "M"
                call add(l:list, l:item.name)
            endif
        endif
    endfor

    if len(l:list) > 0
        call add(l:list, "Commit all")
        call add(l:list, "Quit")
        call s:Git_popup_leave_all_create_popup(l:list)
    else
        if s:quit == 1
            quit
        endif
    endif
endfunction

function! Git_add(filename)
    " Add the file to git
    if exists("b:GitInRepository") && b:GitInRepository == 1
        let l:result = system("git add " . a:filename . " 2>/dev/null")
        let b:GitFileTracked=Git_check_if_file_is_tracked(expand('%:p'))
    endif 

endfunction

function! Git_commit(filename, comment)
    " Comment a file 
    "    echom a:filename . "  " . a:comment
    if exists("b:GitInRepository") && b:GitInRepository == 1
        let l:result = system("git commit " . a:filename . " -m '" . a:comment . "' >/dev/null")
        let b:GitFileTracked=Git_check_if_file_is_tracked(expand('%:p'))
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

    let l:fileStatus = system("git status --porcelain=v1 "  . a:filename . " 2>/dev/null | tr -d '\n'")

    if strlen(l:fileStatus) > 0 
        let l:fileStatus = split(l:fileStatus)[0]
        if l:fileStatus == "??"
            let l:fileStatus = 'U'
        endif
        return l:fileStatus
    endif


    let l:fileStatus = system("git check-ignore "  . a:filename . " 2>/dev/null | tr -d '\n'")
    if strlen(l:fileStatus) > 0
        return 'I'
    endif

    return "P"
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

function! s:Git_save(all)
    if a:all == 1
        wa
        call Git_popup_leave_all(1)
    else
        w
        call Git_popup_leaving(0, 1)
    endif
    echo "Hallo"
endfunction


"cmap <silent> q<CR> :call Git_popup_leaving(0, 1)<CR>
"cmap <silent> qa<CR> :call Git_popup_leave_all(1)<CR>
"cmap <silent> wq<CR> :call s:Git_save(0)<CR>


"augroup GIT_LEAVING
"    au!
"    au QuitPre * : call Git_popup_leaving(0)
"    au ExitPre * : call Git_popup_leaving(0)
"    au VimLeave * : call Git_popup_leaving(0)
"    au VimLeavePre * : call Git_popup_leaving(0)
"augroup end
