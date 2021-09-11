" Managering different configuration in vim


" Create the autocommand group for managering the settings. 
augroup ProjectManager
    au!
augroup END

" A list over projects names 
let s:projects_names = []

" Add a new project to manager
" Takes one required argument the project directory
" And an optional argument the project name
function! project#add(...)
   if a:0 > 2 || a:0 < 1
       echoerr "Adding Project does maximum take two arguments, the project path and project name"
   elseif a:0 == 1
       let l:path = a:000[0]
       call add(s:projects_names, l:path)
    else
       let l:path = a:000[1]
       call add(s:projects_names, a:000[2])
    endif

    execute 'autocmd ProjectManager BufRead ' . l:path .'**.* source ' . l:path . '.vim/project.vim'


    if !project#validate(glob(l:path) . '/.vim/project.vim')
        call project#create(glob(l:path))
    endif
endfunction

" Command
command! -complete=dir -nargs=+ Project :call project#add(<f-args>)


" Validate if project is setup
function! project#validate(path)
   if !empty(glob(a:path))
       return v:true
    endif
    return v:false
endfunction

" Create a project
" Takes one argument, the directory of project
function! project#create(dir)
    call mkdir(a:dir . '/.vim', 'p') 

    if exists('g:project_template')
        call writefile(readfile(g:project_template, "b"), a:dir . '.vim/project.vim', "b")
    else
        call writefile(["let b:project_name=\"project name\""], a:dir . '.vim/project.vim')
    endif
endfunction

command! -complete=dir -nargs=1 ProjectCreate :call project#create(<f-args>)


" Create a sub project 

