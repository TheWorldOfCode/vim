" Default Python settings

" Commands 
command! -nargs=* Python :call <SID>launch(<f-args>)

function! s:launch(...)
    if a:0 == 0
        let l:cmd = expand("%")
        let l:cmd = 'python\ ' . l:cmd
        echo l:cmd
        let l:title = expand("%:t")
        execute 'Terminal ' . l:cmd . ' ' . l:title
    else
        let l:cmd = join(a:000, "\ ") 
        execute 'Terminal python\ ' . l:cmd . ' ' . a:0[1]
    endif
endfunction

" Pipe 8 
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set autoindent
set fileformat=unix
